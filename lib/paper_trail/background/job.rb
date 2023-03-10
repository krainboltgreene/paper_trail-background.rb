module PaperTrail
  module Background
    module Job
      def perform(version_class, attributes, event)
        version = version_class.constantize.create!(attributes)
      end
    end
  end
end
