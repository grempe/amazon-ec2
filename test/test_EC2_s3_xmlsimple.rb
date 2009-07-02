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

# NOTE : These tests exercise amazon-ec2 when used with the aws/s3 gem
# which was demonstrating some breaking behavior.  The fix was to
# add the XmlSimple option "'keeproot' => false" in responses.rb

context "EC2 aws-s3 compat test" do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @describe_instances_response_body = <<-RESPONSE
    <DescribeInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-08-29">
      <reservationSet>
        <item>
          <reservationId>r-44a5402d</reservationId>
          <ownerId>UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM</ownerId>
          <groupSet>
            <item>
              <groupId>default</groupId>
            </item>
          </groupSet>
          <instancesSet>
            <item>
              <instanceId>i-28a64341</instanceId>
              <imageId>ami-6ea54007</imageId>
              <instanceState>
                <code>0</code>
                <name>running</name>
              </instanceState>
              <privateDnsName>domU-12-31-35-00-1E-01.z-2.compute-1.internal</privateDnsName>
              <dnsName>ec2-72-44-33-4.z-2.compute-1.amazonaws.com</dnsName>
              <keyName>example-key-name</keyName>
              <productCodesSet>
                <item><productCode>774F4FF8</productCode></item>
              </productCodesSet>
              <instanceType>m1.small</instanceType>
              <launchTime>2007-08-07T11:54:42.000Z</launchTime>
            </item>
          </instancesSet>
        </item>
      </reservationSet>
    </DescribeInstancesResponse>
    RESPONSE

 end

 specify "should be able to be described and return the correct Ruby response class" do
   @ec2.stubs(:make_request).with('DescribeInstances', {}).
     returns stub(:body => @describe_instances_response_body, :is_a? => true)
   @ec2.describe_instances.should.be.an.instance_of Hash
   response = @ec2.describe_instances
   response.reservationSet.item[0].reservationId.should.equal "r-44a5402d"
 end

 specify "should be able to be described and return the correct Ruby response class when the aws/s3 lib is required" do
   begin
     require 'aws/s3s'
     @ec2.stubs(:make_request).with('DescribeInstances', {}).
       returns stub(:body => @describe_instances_response_body, :is_a? => true)
     @ec2.describe_instances.should.be.an.instance_of Hash
     response = @ec2.describe_instances
     response.reservationSet.item[0].reservationId.should.equal "r-44a5402d"
   rescue LoadError
     # do nothing.  no aws/s3 gem installed to test against
   end
 end

end

