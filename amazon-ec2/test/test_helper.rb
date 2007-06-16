#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Elastic Workbench, LLC
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

%w[ test/unit rubygems test/spec mocha stubba ].each { |f| 
  begin
    require f
  rescue LoadError
    abort "Unable to load required gem for test: #{f}"
  end
}

require File.dirname(__FILE__) + '/../lib/EC2'

