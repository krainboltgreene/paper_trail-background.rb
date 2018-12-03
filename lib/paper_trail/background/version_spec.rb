require "spec_helper"

RSpec.describe PaperTrail::Background::VERSION do
  it "should be a string" do
    expect(PaperTrail::Background::VERSION).to be_kind_of(String)
  end
end
