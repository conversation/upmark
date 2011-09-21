require "bundler/gem_tasks"
require "rspec/core/rake_task"

namespace :spec do
  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = "./spec/acceptance/**/*_spec.rb"
  end

  desc "Run unit specs"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "./spec/unit/**/*_spec.rb"
  end

  desc "Run unit and acceptance specs"
  task :all => [:"spec:unit", :"spec:acceptance"]
end

task default: :"spec:all"
