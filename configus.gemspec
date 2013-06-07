# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "configus/version"

Gem::Specification.new do |s|
  s.name        = "configus"
  s.version     = Configus::VERSION
  s.authors     = ["Mokevnin Kirill"]
  s.email       = ["mokevnin@gmail.com"]
  s.homepage    = "https://github.com/kaize/configus"
  s.summary     = "Configus helps you easily manage environment specific settings"
  s.description = "Configus helps you easily manage environment specific settings"

  s.rubyforge_project = "configus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
