module Dossier
  module Adapter
    class ActiveRecord


      attr_accessor :options, :connection

      def initialize(options = {})
        self.options    = options
      end

      def escape(value)
        active_record_connection.quote(value)
      end

      def execute(query, report_name = nil)
        # Ensure that SQL logs show name of report generating query
        Result.new(active_record_connection.exec_query(*["\n#{query}", report_name].compact))
      rescue => e
        raise Dossier::ExecuteError.new "#{e.message}\n\n#{query}"
      end

      private

      def active_record_connection
        return ::ActiveRecord::Base.connection if ::ActiveRecord::Base.connection.present? && ::ActiveRecord::Base.connected?
        @abstract_class = Class.new(::ActiveRecord::Base) do
          self.abstract_class = true
          
          # Needs a unique name for ActiveRecord's connection pool
          def self.name
            "Dossier::Adapter::ActiveRecord::Connection_#{object_id}"
          end
        end
        @abstract_class.establish_connection(options[:replica])
        @abstract_class.connection
      end
    end
  end
end
