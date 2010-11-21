# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "AWS/version"

Gem::Specification.new do |s|
  s.name        = "amazon-ec2"
  s.version     = AWS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Glenn Rempe"]
  s.email       = ["glenn@rempe.us"]
  s.homepage    = "http://github.com/grempe/amazon-ec2"
  s.summary     = "Amazon EC2 Ruby gem"
  s.description = "A Ruby library for accessing the Amazon Web Services EC2, ELB, RDS, Cloudwatch, and Autoscaling APIs."

  s.rubyforge_project = "amazon-ec2"

  s.rdoc_options = ["--title", "amazon-ec2 documentation", "--line-numbers", "--main", "README.rdoc"]
  s.extra_rdoc_files = [
    "ChangeLog",
    "LICENSE",
    "README.rdoc"
  ]

  s.add_dependency('xml-simple', '>= 1.0.12')
  s.add_development_dependency('mocha', '>= 0.9.9')
  s.add_development_dependency('test-spec', '>= 0.10.0')
  s.add_development_dependency('rcov', '>= 0.9.9')
  s.add_development_dependency('perftools.rb', '>= 0.5.4')
  s.add_development_dependency('yard', '>= 0.6.2')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

