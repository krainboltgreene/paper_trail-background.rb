require 'ar_after_transaction'

require_relative '../paper_trail/background/rspec_helpers'

RSpec.configure do |config|
  config.include PaperTrail::Background::RSpecHelpers::InstanceMethods
  config.extend PaperTrail::Background::RSpecHelpers::ClassMethods
end