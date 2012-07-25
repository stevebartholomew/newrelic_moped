DependencyDetection.defer do
  @name = :moped

  depends_on do
    defined?(::Moped) and not NewRelic::Control.instance['disable_moped']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Moped instrumentation'
  end

  executes do
    Moped::Node.class_eval do
      def process_with_newrelic_trace(operation, &callback)
        collection = operation.collection
        self.class.trace_execution_scoped(["Moped::process[#{collection}]"]) do
          t0 = Time.now

          begin
            process_without_newrelic_trace(operation, &callback)
          ensure
            elapsed_time = (Time.now - t0).to_f
            NewRelic::Agent.instance.transaction_sampler.notice_sql(operation.log_inspect,
                                                     nil, elapsed_time)
            NewRelic::Agent.instance.sql_sampler.notice_sql(operation.log_inspect, nil,
                                                     nil, elapsed_time)
          end
        end
      end

      alias_method :process_without_newrelic_trace, :process
      alias_method :process, :process_with_newrelic_trace
    end
  end
end
