# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)

require "upmark/version"

Gem::Specification.new do |s|
  s.name        = "upmark"
  s.version     = Upmark::VERSION
  s.authors     = ["Josh Bassett", "Gus Gollings"]
  s.email       = "dev@theconversation.edu.au"
  s.homepage    = "https://github.com/conversation/upmark"
  s.summary     = %q{A HTML to Markdown converter}
  s.description = %q{A HTML to Markdown converter}

  s.rubyforge_project = "upmark"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"

  s.add_runtime_dependency "parslet"
end
