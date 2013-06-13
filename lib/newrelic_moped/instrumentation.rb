require 'new_relic/agent/method_tracer'

DependencyDetection.defer do
  @name = :moped

  depends_on do
    defined?(::Moped) && !NewRelic::Control.instance['disable_moped']
  end

  executes do
    NewRelic::Agent.logger.info 'Installing Moped instrumentation'
  end

  executes do
    Moped::Node.class_eval do
      include NewRelic::Moped::Instrumentation
      alias_method :logging_without_newrelic_trace, :logging
      alias_method :logging, :logging_with_newrelic_trace
    end
  end
end

module NewRelic
  module Moped
    module Instrumentation
      def logging_with_newrelic_trace(operations, &blk)
        operation_name, collection = determine_operation_and_collection(operations.first)
        log_statement = operations.first.log_inspect.encode("UTF-8")

        metric = case operation_name
                 when 'INSERT', 'UPDATE', 'CREATE'  then 'save'
                 when 'QUERY', 'COUNT'              then 'find'
                 when 'DELETE'                      then 'destroy'
                 else
                   nil
                 end

        command = Proc.new { logging_without_newrelic_trace(operations, &blk) }
        res = nil

        if metric
          metrics = ["ActiveRecord/#{collection}/#{metric}","ActiveRecord/all"]

          self.class.trace_execution_scoped(metrics) do
            t0 = Time.now
            begin
              res = command.call
            ensure
              elapsed_time = (Time.now - t0).to_f

              NewRelic::Agent.instance.transaction_sampler.notice_sql(log_statement, nil, elapsed_time)
              NewRelic::Agent.instance.sql_sampler.notice_sql(log_statement, metric, nil, elapsed_time)
            end
          end
        else
          res = command.call
        end

        res
      end

      def determine_operation_and_collection(operation)
        log_statement = operation.log_inspect.encode("UTF-8")
        collection = "Unknown"
        if operation.respond_to?(:collection)
          collection = operation.collection
        end
        operation_name = log_statement.split[0]
        if operation_name == 'COMMAND' && log_statement.include?(":mapreduce")
          operation_name = 'MAPREDUCE'
          collection = log_statement[/:mapreduce=>"([^"]+)/,1]
        elsif operation_name == 'COMMAND' && log_statement.include?(":count")
          operation_name = 'COUNT'
          collection = log_statement[/:count=>"([^"]+)/,1]
        end
        return operation_name, collection
      end
    end
  end
end
