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

context "EC2 availability zones" do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @describe_availability_zones_response_body = <<-RESPONSE
    <DescribeAvailabilityZonesResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01/">
      <availabilityZoneInfo>
        <item>
          <zoneName>us-east-1a</zoneName>
          <zoneState>available</zoneState>
        </item>
        <item>
          <zoneName>us-east-1b</zoneName>
          <zoneState>available</zoneState>
        </item>
      </availabilityZoneInfo>
    </DescribeAvailabilityZonesResponse>
    RESPONSE

 end

  specify "should be able to be described with describe_availability_zones" do
    @ec2.stubs(:make_request).with('DescribeAvailabilityZones', { "ZoneName.1" => "us-east-1a", "ZoneName.2" => "us-east-1b" }).
      returns stub(:body => @describe_availability_zones_response_body, :is_a? => true)
    @ec2.describe_availability_zones( :zone_name => ["us-east-1a", "us-east-1b"] ).should.be.an.instance_of Hash

    response = @ec2.describe_availability_zones( :zone_name => ["us-east-1a", "us-east-1b"] )

    response.availabilityZoneInfo.item[0].zoneName.should.equal "us-east-1a"
    response.availabilityZoneInfo.item[0].zoneState.should.equal "available"

    response.availabilityZoneInfo.item[1].zoneName.should.equal "us-east-1b"
    response.availabilityZoneInfo.item[1].zoneState.should.equal "available"
  end

end
