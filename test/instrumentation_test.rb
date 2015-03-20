require 'ostruct'
require 'test/unit'
require 'moped'

require File.expand_path(File.dirname(__FILE__) + '/../lib/newrelic_moped/instrumentation')
require File.expand_path(File.dirname(__FILE__) + '/moped_command_fake')

require 'newrelic_rpm'
NewRelic::Agent.require_test_helper

class FakeOpWithCollection < Struct.new(:collection, :log_inspect)
end

class FakeOpWithoutCollection < Struct.new(:log_inspect)
end

class TestInstrumentation < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def setup
    @session = Moped::Session.new([ "127.0.0.1:27017" ])
    @session.use "newrelic_moped_test"

    NewRelic::Agent.drop_buffered_data
  end

  def test_insert_generates_metrics
    @session.with(safe: true) do |safe|
      safe[:artists].insert(name: "Syd Vicious")
    end

    assert_metrics_recorded_exclusive(
      [
        'Datastore/all',
        'Datastore/allOther',
        'Datastore/MongoDB/all',
        'Datastore/MongoDB/allOther',
        'Datastore/operation/MongoDB/save',
        'Datastore/statement/MongoDB/artists/save'
      ]
    )
  end

  def test_find_generates_metrics
    NewRelic::Agent.disable_all_tracing do
      @session.with(safe: true) do |safe|
        safe[:artists].insert(name: "The Doubleclicks")
      end
    end

    @session[:artists].find(name: "The Doubleclicks").first

    assert_metrics_recorded_exclusive(
      [
        'Datastore/all',
        'Datastore/allOther',
        'Datastore/MongoDB/all',
        'Datastore/MongoDB/allOther',
        'Datastore/operation/MongoDB/find',
        'Datastore/statement/MongoDB/artists/find'
      ]
    )
  end

  def test_update_generates_metrics
    query = nil
    NewRelic::Agent.disable_all_tracing do
      @session.with(safe: true) do |safe|
        safe[:artists].insert(name: "The Doubleclicks")
      end

      query = @session[:artists].find(name: "The Doubleclicks")
    end

    query.update(instruments: { name: "Cat Piano" })

    assert_metrics_recorded_exclusive(
      [
        'Datastore/all',
        'Datastore/allOther',
        'Datastore/MongoDB/all',
        'Datastore/MongoDB/allOther',
        'Datastore/operation/MongoDB/save',
        'Datastore/statement/MongoDB/artists/save'
      ]
    )
  end

  def test_remove_generates_metrics
    query = nil
    NewRelic::Agent.disable_all_tracing do
      @session.with(safe: true) do |safe|
        safe[:artists].insert(name: "The Doubleclicks")
      end

      query = @session[:artists].find(name: "The Doubleclicks")
    end

    query.remove

    assert_metrics_recorded_exclusive(
      [
        'Datastore/all',
        'Datastore/allOther',
        'Datastore/MongoDB/all',
        'Datastore/MongoDB/allOther',
        'Datastore/operation/MongoDB/destroy',
        'Datastore/statement/MongoDB/artists/destroy'
      ]
    )
  end
end

class NewRelicMopedInstrumentationTest < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::Moped

  def test_when_command_is_aggregate
    command = MopedCommandWithCollectionFake.new("COMMAND database=my_database command={:aggregate=>\"users\", pipeline=>[]}", "other_collection")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("AGGREGATE", operation)
    assert_equal("users", collection, "it should parse collection from statement")
  end

  def test_when_command_is_find_and_modify
    command = MopedCommandWithCollectionFake.new("COMMAND database=my_database command={:findAndModify=>\"users\", :query=>{\"_id\"=>\"548d12c020076592be0000a0\"}, :update=>{\"$set\"=>{\"foo\"=>\"bar\"}}}", "other_collection")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("FIND_AND_MODIFY", operation)
    assert_equal("users", collection, "it should parse collection from statement")
  end

  def test_when_command_is_mapreduce
    command = MopedCommandWithCollectionFake.new("COMMAND database=my_database command={:mapreduce=>\"users\", :query=>{}}", "other_collection")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("MAPREDUCE", operation)
    assert_equal("users", collection, "it should parse collection from statement")
  end

  def test_query_when_operation_responds_to_collection
    command = MopedCommandWithCollectionFake.new("QUERY database=my_database collection=xyz", "users")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("QUERY", operation)
    assert_equal("users", collection, "it should use collection from operation")
  end

  def test_when_command_is_count
    command = MopedCommandWithCollectionFake.new("COMMAND database=my_database command={:count=>\"users\", query=>{}}", "other_collection")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("COUNT", operation)
    assert_equal("users", collection, "it should parse collection from statement")
  end

  def test_when_command_is_get_more
    command = MopedCommandWithCollectionFake.new("GET_MORE database=my_database collection=users limit=0 cursor_id=113473787917252684", "users")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("GET_MORE", operation)
    assert_equal("users", collection, "it should parse collection from statement")
  end

  def test_command_when_operation_does_not_respond_to_collection
    command = MopedCommandFake.new("COMMAND database=admin command={:ismaster=>1}")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("COMMAND", operation)
    assert_equal("Unknown", collection, "it should set collection name to Unknown")
  end
end
