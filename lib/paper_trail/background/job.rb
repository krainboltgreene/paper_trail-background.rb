# frozen_string_literal: true

module PaperTrail
  module Background
    module Job
      def perform(version_class, attributes, _event)
        version_class.constantize.create!(attributes)
      end
    end
  end
end
