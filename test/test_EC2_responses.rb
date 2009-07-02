#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The Response classes " do


  before do
    @http_xml = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </RebootInstancesResponse>
    RESPONSE

    @response = AWS::Response.parse(:xml => @http_xml)
  end


  specify "should show the response as a formatted string when calling #inspect" do
    # sorting the response hash first since ruby 1.8.6 and ruby 1.9.1 sort the hash differently before the inspect
    @response.sort.inspect.should.equal %{[[\"return\", \"true\"], [\"xmlns\", \"http://ec2.amazonaws.com/doc/2007-03-01\"]]}
  end


  specify "should be a Hash" do
    @response.kind_of?(Hash).should.equal true
  end


  specify "should return its members" do
    @response.keys.length.should.equal 2
    test_array = ["return", "xmlns"].sort
    @response.keys.sort.should.equal test_array
  end


  # Note: since we are now returning a hash of the xml, there should be no need for anyone to re-parse the xml.
  # Therefore storing the xml on the object is a waste of memory, and is not done.
  #
  # specify "should return the original amazon XML response in the 'xml' attribute of the response object." do
  #  @response.xml.should.equal @http_xml
  # end


end
