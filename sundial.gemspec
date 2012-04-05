# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sundial/version"

Gem::Specification.new do |s|
  s.name        = "sundial"
  s.version     = Sundial::VERSION
  s.authors     = ["Bob Larrick"]
  s.email       = ["larrick@gmail.com"]
  s.homepage    = "https://github.com/deathbob/Sundial"
  s.summary     = %q{Gem to calculate the sunrise and sunset at your location}
  s.description = %q{This gem calculates the sunrise and sunset at your current location.}

  s.rubyforge_project = "sundial"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "geokit"  
  
end
