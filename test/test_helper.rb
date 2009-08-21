#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require 'rubygems'
gem 'test-unit'

%w[ test/unit test/spec mocha ].each { |f|
  begin
    require f
  rescue LoadError
    abort "Unable to load required gem for test: #{f}"
  end
}

require File.dirname(__FILE__) + '/../lib/AWS'

