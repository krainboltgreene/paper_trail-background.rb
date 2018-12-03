#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all the tests in spec"
RSpec::Core::RakeTask.new(:spec) do |let|
  let.pattern = "lib/**{,/*/**}/*_spec.rb"
end

desc "Default: run tests"
task default: :spec
