module PaperTrail
  module Background
    class Configuration
      attr_accessor :opt_in
    end

    class Config
      class << self
        def configuration
          @configuration ||= Configuration.new
        end

        def configure
          yield(configuration)
        end
      end
    end
  end
end
