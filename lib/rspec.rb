require 'ar_after_transaction'

require_relative 'paper_trail/background/rspec_helpers'

RSpec.configure do |config|
  config.include PaperTrailBackgroundRspecHelpers::InstanceMethods
  config.extend PaperTrailBackgroundRspecHelpers::ClassMethods
end