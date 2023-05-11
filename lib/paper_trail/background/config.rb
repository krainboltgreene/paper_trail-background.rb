module PaperTrail
  module Background
    class Configuration
      attr_reader :opt_in

      def opt_in=(value)
        @opt_in = value
      end
    end

    class Config
      class << self
        def configuration
          @configuration ||= Configuration.new
        end

        def configure(&block)
          yield(configuration)
        end
      end
    end
  end
end
