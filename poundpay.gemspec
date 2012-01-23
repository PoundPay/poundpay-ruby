# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "poundpay/version"

Gem::Specification.new do |s|
  s.name        = "poundpay"
  s.version     = Poundpay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matin Tamizi"]
  s.email       = "devsupport@poundpay.com"
  s.homepage    = "http://github.com/poundpay/poundpay-ruby"
  s.summary     = %q{Poundpay Ruby library}
  s.description = %q{Payments platform for marketplaces}

  s.rubyforge_project = "poundpay"

  s.add_dependency("activeresource", "~> 3.1.0")

  s.add_development_dependency("rspec", ">= 2.0")
  s.add_development_dependency("wirble")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
