require 'ostruct'
require 'test/unit'
require 'moped'

require File.expand_path(File.dirname(__FILE__) + '/../lib/newrelic_moped/instrumentation')

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
      def process_without_newrelic_trace(operation, &callback)
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
      @node.process_with_newrelic_trace(fake_op)
    end
  end

  def test_ignores_operations_without_collection
    fake_op = FakeOpWithoutCollection.new("Fake")

    assert_nothing_raised do
      @node.process_with_newrelic_trace(fake_op) 
    end
  end
end
