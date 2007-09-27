#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:grempe@rubyforge.org)
# Copyright:: Copyright (c) 2007 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The Response classes " do
  
  
  setup do
    @http_xml = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    
    @response = EC2::Response.parse(:xml => @http_xml)
    
    # test out adding arbitrary new values to the OpenStruct
    @response.name = "foo"
    @response.number = '123'
  end
  
  
  specify "should properly run the to_string(short) method for the short version" do
    # sample response looks like: "#<EC2::Response:0x100A45F2E ...>".  Our response should look 
    # exactly the same, except it should have different hex digits in the middle (after 0x) 
    # that are nine chars long.
    @response.to_string(true).should =~ /^#<EC2::Response:0x[0-9A-F]{1,9} ...>/
  end
  
  
  specify "should properly run the to_string(false) method for the long version" do
    @response.to_string(false).should =~ /^#<EC2::Response:0x[0-9A-F]{1,9} name=\"foo\" number=\"123\" parent=nil return=\"true\"/
  end
  
  
  specify "should properly run the to_string(false) method for the long version when called with no params" do
    @response.to_string.should =~ /^#<EC2::Response:0x[0-9A-F]{1,9} name=\"foo\" number=\"123\" parent=nil return=\"true\"/
  end
  
  
  specify "should provide the same results from to_s as from to_string(false) " do
    @response.to_s.should =~ /^#<EC2::Response:0x[0-9A-F]{1,9} name=\"foo\" number=\"123\" parent=nil return=\"true\"/
  end
  
  
  specify "should be a kind of type OpenStruct" do
    @response.kind_of?(OpenStruct).should.equal true
    @response.kind_of?(Enumerable).should.equal true
  end
  
  
  specify "should return its members" do
    @response.members.length.should.equal 6
    test_array = ["return", "xmlns", "number", "name", "parent", "xml"].sort
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
  
  specify "should return the original amazon XML response in the 'xml' attribute of the response object." do
    @response.xml.should.equal @http_xml
  end
  
  
end
