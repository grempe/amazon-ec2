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

context "An EC2 spot instances request " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @create_spot_instances_request_response_body = <<-RESPONSE
    <RequestSpotInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <spotInstanceRequestSet>
        <item>
          <spotInstanceRequestId>sir-f102a405</spotInstanceRequestId>
          <spotPrice>0.50</spotPrice>
          <type>one-time</type>
          <state>open</state>
          <fault/>
          <validFrom/>
          <validUntil/>
          <launchGroup/>
          <availabilityZoneGroup>MyAzGroup</availabilityZoneGroup>
          <launchSpecification>
            <imageId> i-43a4412a</imageId>
            <keyName>MyKeypair</keyName>
            <groupSet>websrv</groupSet>
            <instanceType>m1.small</instanceType>
          </launchSpecification>
          <instanceId>i-123345678</instanceId>
          <createTime>2009-10-19T00:00:00+0000</createTime>
          <productDescription/>
        </item>
      </spotInstanceRequestSet>
    </RequestSpotInstancesResponse>
    RESPONSE

    @describe_spot_instance_requests_response_body = <<-RESPONSE
    <DescribeSpotInstanceRequestsResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <spotInstanceRequestSet>
        <item>
          <spotInstanceRequestId>sir-e95fae02</spotInstanceRequestId>
          <spotPrice>0.01</spotPrice>
          <type>one-time</type>
          <state>open</state>
          <createTime>2009-12-04T22:51:14.000Z</createTime>
          <productDescription>Linux/UNIX</productDescription>
          <launchSpecification>
            <imageId>ami-235fba4a</imageId>
            <groupSet>
              <item>
                <groupId>default</groupId>
              </item>
            </groupSet>
            <instanceType>m1.small</instanceType>
            <blockDeviceMapping/>
            <monitoring>
              <enabled>false</enabled>
            </monitoring>
          </launchSpecification>
          <instanceId>i-2fd4ca67</instanceId>
        </item>
        <item>
          <spotInstanceRequestId>sir-e95fae03</spotInstanceRequestId>
          <spotPrice>0.10</spotPrice>
          <type>persistent</type>
          <state>open</state>
          <createTime>2009-12-04T22:51:14.000Z</createTime>
          <productDescription>Linux/UNIX</productDescription>
          <launchSpecification>
            <imageId>ami-235fba4a</imageId>
            <groupSet>
              <item>
                <groupId>default</groupId>
              </item>
            </groupSet>
            <instanceType>m1.medium</instanceType>
            <blockDeviceMapping/>
            <monitoring>
              <enabled>false</enabled>
            </monitoring>
          </launchSpecification>
          <instanceId>i-2fd4ca90</instanceId>
        </item>
      </spotInstanceRequestSet>
    </DescribeSpotInstanceRequestsResponse>
    RESPONSE

    @cancel_spot_instance_requests_response_body = <<-RESPONSE
    <CancelSpotInstanceRequestsResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <requestId>59dbff89-35bd-4eac-99ed-be587ed81825</requestId>
      <spotInstanceRequestSet>
        <item>
          <spotInstanceRequestId>sir-e95fae02</spotInstanceRequestId>
          <state>cancelled</state>
        </item>
      </spotInstanceRequestSet>
    </CancelSpotInstanceRequestsResponse>
    RESPONSE

  end

  specify "should be able to be requested with various instance sizes" do
    ["t1.micro", "m1.small", "m1.large", "m1.xlarge", "m2.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge", "cc1.4xlarge"].each do |type|
      @ec2.stubs(:make_request).with('RequestSpotInstances', {"SpotPrice"=>"0.50", 'LaunchSpecification.InstanceType' => type, 'LaunchSpecification.ImageId' => 'ami-60a54009', "InstanceCount"=>"1"}).
        returns stub(:body => @create_spot_instances_request_response_body, :is_a? => true)
      lambda { @ec2.request_spot_instances( :image_id => "ami-60a54009", :instance_type => type, :spot_price => '0.50' ) }.should.not.raise(AWS::ArgumentError)
    end
  end

  specify "should raise an exception with a bad instance type" do
    lambda { @ec2.request_spot_instances({"SpotPrice"=>"0.50", 'LaunchSpecification.InstanceType' => 'm1.notarealsize', "InstanceCount"=>"1"}) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('RequestSpotInstances', {"SpotPrice"=>"0.50", 'LaunchSpecification.InstanceType' => 'm1.small', "InstanceCount"=>"1"}).
      returns stub(:body => @create_spot_instances_request_response_body, :is_a? => true)
    @ec2.request_spot_instances(:spot_price => "0.50").should.be.an.instance_of Hash
    @ec2.request_spot_instances(:spot_price => "0.50").spotInstanceRequestSet.item[0].spotInstanceRequestId.should.equal "sir-f102a405"
  end


  specify "method create_spot_instances_request should raise an exception when called with nil/empty string arguments" do
    lambda { @ec2.request_spot_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.request_spot_instances(:spot_price => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.request_spot_instances(:spot_price => nil) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be described and return the correct Ruby response class for parent and members" do
    @ec2.stubs(:make_request).with('DescribeSpotInstanceRequests', {}).
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_spot_instance_requests.should.be.an.instance_of Hash
    response = @ec2.describe_spot_instance_requests
    response.should.be.an.instance_of Hash
  end


  specify "should be able to be described with no params and return a spotInstanceRequestSet" do
    @ec2.stubs(:make_request).with('DescribeSpotInstanceRequests', {}).
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_spot_instance_requests.spotInstanceRequestSet.item.length.should.equal 2
  end

  specify "should be able to be described by an Array of SpotInstanceRequestId.N ID's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeSpotInstanceRequests', {"SpotInstanceRequestId.1"=>"sir-e95fae02", "SpotInstanceRequestId.2"=>"sir-e95fae03"}).
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_spot_instance_requests( :spot_instance_request_id => ["sir-e95fae02", "sir-e95fae03"] ).spotInstanceRequestSet.item.length.should.equal 2

    response = @ec2.describe_spot_instance_requests( :spot_instance_request_id => ["sir-e95fae02", "sir-e95fae03"] )

    # test first 'Item' object returned
    response.spotInstanceRequestSet.item[0].spotInstanceRequestId.should.equal "sir-e95fae02"
    response.spotInstanceRequestSet.item[0].spotPrice.should.equal "0.01"
    response.spotInstanceRequestSet.item[0].type.should.equal "one-time"
    response.spotInstanceRequestSet.item[0].state.should.equal "open"
    response.spotInstanceRequestSet.item[0].createTime.should.equal "2009-12-04T22:51:14.000Z"
    response.spotInstanceRequestSet.item[0].productDescription.should.equal "Linux/UNIX"
    response.spotInstanceRequestSet.item[0].launchSpecification.imageId.should.equal "ami-235fba4a"
    response.spotInstanceRequestSet.item[0].launchSpecification.instanceType.should.equal "m1.small"
    response.spotInstanceRequestSet.item[0].instanceId.should.equal "i-2fd4ca67"

    # test second 'Item' object returned
    response.spotInstanceRequestSet.item[1].spotInstanceRequestId.should.equal "sir-e95fae03"
    response.spotInstanceRequestSet.item[1].spotPrice.should.equal "0.10"
    response.spotInstanceRequestSet.item[1].type.should.equal "persistent"
    response.spotInstanceRequestSet.item[1].state.should.equal "open"
    response.spotInstanceRequestSet.item[1].createTime.should.equal "2009-12-04T22:51:14.000Z"
    response.spotInstanceRequestSet.item[1].productDescription.should.equal "Linux/UNIX"
    response.spotInstanceRequestSet.item[1].launchSpecification.imageId.should.equal "ami-235fba4a"
    response.spotInstanceRequestSet.item[1].launchSpecification.instanceType.should.equal "m1.medium"
    response.spotInstanceRequestSet.item[1].instanceId.should.equal "i-2fd4ca90"
  end

  specify "should be able to be destroyed" do
    @ec2.stubs(:make_request).with('CancelSpotInstanceRequests', {"SpotInstanceRequestId.1"=>"sir-e95fae02"}).
      returns stub(:body => @cancel_spot_instance_requests_response_body, :is_a? => true)
    @ec2.cancel_spot_instance_requests(:spot_instance_request_id => "sir-e95fae02" ).should.be.an.instance_of Hash
    @ec2.cancel_spot_instance_requests(:spot_instance_request_id => "sir-e95fae02" ).spotInstanceRequestSet.item[0].state.should.equal "cancelled"
  end

end
