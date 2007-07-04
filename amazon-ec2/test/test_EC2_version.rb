#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The EC2 Gem " do
  
  
  setup do
    @major = 0
    @minor = 2
    @tiny = 2
    @string = [@major, @minor, @tiny].join('.')
  end
  
  
  specify "should have an up to date MAJOR version" do
    EC2::VERSION::MAJOR.should.equal @major
  end
  
  
  specify "should have an up to date MINOR version" do
    EC2::VERSION::MINOR.should.equal @minor
  end
  
  
  specify "should have an up to date TINY version" do
    EC2::VERSION::TINY.should.equal @tiny
  end
  
  
  specify "should return a proper version string when #STRING is called" do
    EC2::VERSION::STRING.should.equal @string
  end
  
  
end