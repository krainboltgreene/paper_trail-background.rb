require "spec_helper"

RSpec.describe PaperTrail::Background::VERSION do
  it "is a string" do
    expect(PaperTrail::Background::VERSION).to be_a(String)
  end
end
