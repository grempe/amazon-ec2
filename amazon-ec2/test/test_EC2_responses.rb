#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Elastic Workbench, LLC
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The Response classes " do
  
  
  setup do
    http_xml = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
      <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    
    @response = EC2::Response.parse(:xml => http_xml)
    
    # test out adding arbitrary new values to the OpenStruct
    @response.name = "foo"
    @response.number = '123'
  end
  
  
  specify "should be a kind of type OpenStruct" do
    @response.kind_of?(OpenStruct).should.equal true
    @response.kind_of?(Enumerable).should.equal true
  end
  
  
  specify "should return its members" do
    @response.members.length.should.equal 4
    test_array = ["return", "xmlns", "number", "name"].sort
    @response.members.sort.should.equal test_array
  end
  
  
  specify "should properly respond to its 'each' method" do
    answer = @response.each do |f| f ; end
    answer.name.should.equal "foo"
    answer.number.should.equal '123'
  end
  
  
  specify "should respond to the '[]' method" do
    @response[:name].should.equal "foo"
  end
  
  
  specify "should respond correctly to the '[]=' method and set a variable" do
    @response[:name].should.equal "foo"
    @response[:name]="bar"
    @response[:name].should.equal "bar"
  end
  
  
  specify "should respond correctly to the 'each_pair' method" do
    @response.each_pair {|k,v|
      case k
      when "name"
        v.should.equal "foo"
      when "number"
        v.should.equal '123'
      end
    }
  end
  
  
end