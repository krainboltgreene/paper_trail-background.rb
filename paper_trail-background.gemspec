require_relative "lib/paper_trail/background/version"

Gem::Specification.new do |spec|
  spec.name = "paper_trail-background"
  spec.version = PaperTrail::Background::VERSION
  spec.authors = ["Kurtis Rainbolt-Greene"]
  spec.email = ["kurtis@rainbolt-greene.online"]
  spec.summary = %q{A library for making paper_trail a background process}
  spec.description = spec.summary
  spec.homepage = "https://github.com/krainboltgreene/paper_trail-background.rb"
  spec.license = "HL3"

  spec.files = Dir[File.join("lib", "**", "*"), "LICENSE", "README.md", "Rakefile"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rake", "~> 12.2"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "pry-doc", "0.11.1"
  spec.add_runtime_dependency "ar_after_transaction", "~> 0.10.0"
  spec.add_runtime_dependency "paper_trail", ">= 10"
end
