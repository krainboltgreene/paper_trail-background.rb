require_relative "lib/paper_trail/background/version"

Gem::Specification.new do |spec|
  spec.name = "paper_trail-background"
  spec.version = PaperTrail::Background::VERSION
  spec.authors = ["Kurtis Rainbolt-Greene"]
  spec.email = ["kurtis@rainbolt-greene.online"]
  spec.summary = "A library for making paper_trail a background process"
  spec.description = spec.summary
  spec.homepage = "https://github.com/krainboltgreene/paper_trail-background.rb"
  spec.license = "HL3"
  spec.required_ruby_version = "~> 3.2"

  spec.files = Dir[File.join("lib", "**", "*"), "LICENSE", "README.md", "Rakefile"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ar_after_transaction", "~> 0.10.0"
  spec.add_runtime_dependency "paper_trail", ">= 10"
  spec.metadata["rubygems_mfa_required"] = "true"
end
