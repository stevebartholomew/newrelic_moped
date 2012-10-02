require 'ostruct'
require 'test/unit'
require 'moped'

require File.expand_path(File.dirname(__FILE__) + '/../lib/newrelic_moped/instrumentation')
require File.expand_path(File.dirname(__FILE__) + '/moped_command_fake')

class FakeOpWithCollection < Struct.new(:collection, :log_inspect)
end

class FakeOpWithoutCollection < Struct.new(:log_inspect)
end

class TestInstrumentation < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def setup
    DependencyDetection.detect!
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats

    @sampler = NewRelic::Agent.instance.transaction_sampler
    @sampler.enable
    @sampler.reset!
    @sampler.start_builder

    Moped::Node.class_eval do
      def logging_with_newrelic_trace(operations, &callback)
        # do nothing
      end
    end

    @node = Moped::Node.new("127.0.0.1:27017")
  end

  def teardown
    @sampler.clear_builder
  end

  def test_handles_operations_with_collections
    fake_op = FakeOpWithCollection.new([], "Fake")

    assert_nothing_raised do
      @node.logging_with_newrelic_trace(fake_op)
    end
  end

  def test_ignores_operations_without_collection
    fake_op = FakeOpWithoutCollection.new("Fake")

    assert_nothing_raised do
      @node.logging_with_newrelic_trace(fake_op)
    end
  end
end

class NewRelicMopedInstrumentationTest < Test::Unit::TestCase
  include NewRelic::Moped::Instrumentation

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

  def test_command_when_operation_does_not_respond_to_collection
    command = MopedCommandFake.new("COMMAND database=admin command={:ismaster=>1}")
    operation, collection = determine_operation_and_collection(command)
    assert_equal("COMMAND", operation)
    assert_equal("Unknown", collection, "it should set collection name to Unknown")
  end
end