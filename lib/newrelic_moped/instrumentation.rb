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
        
        self.class.trace_execution_scoped(["Moped::Node#process"]) do
          t0 = Time.now

          begin
            process_without_newrelic_trace(operation, &callback)
          ensure
            NewRelic::Agent.instance.transaction_sampler.notice_nosql(operation.log_inspect, (Time.now - t0).to_f) 
          end
        end
      end

      alias_method :process_without_newrelic_trace, :process
      alias_method :process, :process_with_newrelic_trace
    end
  end
end
