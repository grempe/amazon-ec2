#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2010 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The EC2 subnets " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @describe_subnets_response_body = <<-RESPONSE
      <DescribeSubnetsResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01">
        <subnetSet>
          <item>
            <state>available</state>
            <availableIpAddressCount>251</availableIpAddressCount>
            <subnetId>subnet-000000e0</subnetId>
            <cidrBlock>10.225.251.0/24</cidrBlock>
            <vpcId>vpc-b00000db</vpcId>
            <availabilityZone>us-east-1a</availabilityZone>
         </item>
          <item>
            <state>available</state>
            <availableIpAddressCount>251</availableIpAddressCount>
            <subnetId>subnet-11111!e1</subnetId>
            <cidrBlock>10.225.251.0/24</cidrBlock>
            <vpcId>vpc-b00000db</vpcId>
            <availabilityZone>us-east-1a</availabilityZone>
         </item>
       </subnetSet>
    </DescribeSubnetsResponse>
    RESPONSE

  end


  specify "should be able to be described with no params and return a subnetSet" do
    @ec2.stubs(:make_request).with('DescribeSubnets', {}).
      returns stub(:body => @describe_subnets_response_body, :is_a? => true)
    @ec2.describe_subnets.subnetSet.item.length.should.equal 2
  end


  specify "should be able to be described with describe_subnet" do
    @ec2.stubs(:make_request).with('DescribeSubnets', {"SubnetId.1"=>"subnet-000000e0"}).
      returns stub(:body => @describe_subnets_response_body, :is_a? => true)
    @ec2.describe_subnets( :subnet_id => "subnet-000000e0" ).should.be.an.instance_of Hash
    response = @ec2.describe_subnets( :subnet_id => "subnet-000000e0" )
    response.subnetSet.item[0].state.should.equal "available"
    response.subnetSet.item[0].availableIpAddressCount.should.equal "251"
    response.subnetSet.item[0].subnetId.should.equal "subnet-000000e0"
    response.subnetSet.item[0].cidrBlock.should.equal "10.225.251.0/24"
    response.subnetSet.item[0].vpcId.should.equal "vpc-b00000db"
    response.subnetSet.item[0].availabilityZone.should.equal "us-east-1a"
  end

end

