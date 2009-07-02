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

context "An EC2 instance " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @confirm_product_instance_response_body = <<-RESPONSE
    <ConfirmProductInstanceResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <result>true</result>
      <ownerId>254933287430</ownerId>
    </ConfirmProductInstanceResponse>
    RESPONSE

  end


  specify "should indicate whether a product code is attached to an instance" do
    @ec2.stubs(:make_request).with('ConfirmProductInstance', {"ProductCode"=>"774F4FF8", "InstanceId"=>"i-10a64379"}).
       returns stub(:body => @confirm_product_instance_response_body, :is_a? => true)

    @ec2.confirm_product_instance( :product_code => "774F4FF8", :instance_id => "i-10a64379" ).should.be.an.instance_of Hash
    response = @ec2.confirm_product_instance( :product_code => "774F4FF8", :instance_id => "i-10a64379" )
    response.ownerId.should.equal "254933287430"
    response.result.should.equal "true"
  end


  specify "method get_console_output should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.confirm_product_instance() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.confirm_product_instance(:product_code => "774F4FF8", :instance_id => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.confirm_product_instance(:product_code => "774F4FF8", :instance_id => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.confirm_product_instance(:product_code => nil, :instance_id => "i-10a64379") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.confirm_product_instance(:product_code => "", :instance_id => "i-10a64379") }.should.raise(AWS::ArgumentError)
  end


end