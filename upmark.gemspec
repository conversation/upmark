# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "upmark"
  s.version     = "0.1.4"
  s.authors     = ["Josh Bassett", "Gus Gollings"]
  s.email       = "dev@theconversation.edu.au"
  s.homepage    = "http://github.com/conversation/upmark"
  s.summary     = %q{A HTML to Markdown converter.}
  s.description = %q{Upmark has the skills to convert your HTML to Markdown.}

  s.rubyforge_project = "upmark"

  s.files       =  Dir.glob("{lib,spec}/**/*") + ["Rakefile","LICENSE","README.md"]
  s.test_files  =  Dir.glob("{spec}/**/*")
  s.executables = ["upmark"]

  s.add_development_dependency "rspec", "~> 2.0", "< 2.99"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov"

  s.add_runtime_dependency "parslet"
end
