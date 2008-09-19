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

context "EC2 instances " do

  setup do
    @ec2 = EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @run_instances_response_body = <<-RESPONSE
    <RunInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-08-29">
      <reservationId>r-47a5402e</reservationId>
      <ownerId>495219933132</ownerId>
      <groupSet>
        <item>
          <groupId>default</groupId>
        </item>
      </groupSet>
      <instancesSet>
        <item>
          <instanceId>i-2ba64342</instanceId>
          <imageId>ami-60a54009</imageId>
          <instanceState>
            <code>0</code>
            <name>pending</name>
          </instanceState>
          <privateDnsName></privateDnsName>
          <dnsName></dnsName>
          <keyName>example-key-name</keyName>
           <amiLaunchIndex>0</amiLaunchIndex>
          <instanceType>m1.small</instanceType>
          <launchTime>2007-08-07T11:51:50.000Z</launchTime>
        </item>
        <item>
          <instanceId>i-2bc64242</instanceId>
          <imageId>ami-60a54009</imageId>
          <instanceState>
            <code>0</code>
            <name>pending</name>
          </instanceState>
          <privateDnsName></privateDnsName>
          <dnsName></dnsName>
          <keyName>example-key-name</keyName>
          <amiLaunchIndex>1</amiLaunchIndex>
          <instanceType>m1.small</instanceType>
          <launchTime>2007-08-07T11:51:50.000Z</launchTime>
        </item>
        <item>
          <instanceId>i-2be64332</instanceId>
          <imageId>ami-60a54009</imageId>
          <instanceState>
            <code>0</code>
     <name>pending</name>
          </instanceState>
          <privateDnsName></privateDnsName>
          <dnsName></dnsName>
          <keyName>example-key-name</keyName>
          <amiLaunchIndex>2</amiLaunchIndex>
          <instanceType>m1.small</instanceType>
          <launchTime>2007-08-07T11:51:50.000Z</launchTime>
        </item>
      </instancesSet>
    </RunInstancesResponse>
    RESPONSE

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

    @reboot_instances_response_body = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </RebootInstancesResponse>
    RESPONSE

    @terminate_instances_response_body = <<-RESPONSE
    <TerminateInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <instancesSet>
        <item>
          <instanceId>i-28a64341</instanceId>
          <shutdownState>
            <code>32</code>
            <name>shutting-down</name>
          </shutdownState>
          <previousState>
            <code>0</code>
            <name>pending</name>
          </previousState>
        </item>
        <item>
          <instanceId>i-21a64348</instanceId>
          <shutdownState>
            <code>32</code>
            <name>shutting-down</name>
          </shutdownState>
          <previousState>
            <code>0</code>
            <name>pending</name>
          </previousState>
        </item>
      </instancesSet>
    </TerminateInstancesResponse>
    RESPONSE
  end


  specify "should be able to be run" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "AddressingType" => 'public', 'InstanceType' => 'm1.small').
      returns stub(:body => @run_instances_response_body, :is_a? => true)

    @ec2.run_instances( :image_id => "ami-60a54009" ).should.be.an.instance_of Hash

    response = @ec2.run_instances( :image_id => "ami-60a54009" )

    response.reservationId.should.equal "r-47a5402e"
    response.ownerId.should.equal "495219933132"

    response.groupSet.item[0].groupId.should.equal "default"

    response.instancesSet.item.length.should.equal 3

    response.instancesSet.item[0].instanceId.should.equal "i-2ba64342"
    response.instancesSet.item[0].imageId.should.equal "ami-60a54009"
    response.instancesSet.item[0].instanceState.code.should.equal "0"
    response.instancesSet.item[0].instanceState.name.should.equal "pending"
    response.instancesSet.item[0].privateDnsName
    response.instancesSet.item[0].dnsName.should.be.nil
    response.instancesSet.item[0].keyName.should.equal "example-key-name"
    response.instancesSet.item[0].instanceType.should.equal "m1.small"
    response.instancesSet.item[0].launchTime.should.equal "2007-08-07T11:51:50.000Z"

    response.instancesSet.item[1].instanceId.should.equal "i-2bc64242"
    response.instancesSet.item[1].imageId.should.equal "ami-60a54009"
    response.instancesSet.item[1].instanceState.code.should.equal "0"
    response.instancesSet.item[1].instanceState.name.should.equal "pending"
    response.instancesSet.item[1].privateDnsName
    response.instancesSet.item[1].dnsName.should.be.nil
    response.instancesSet.item[1].keyName.should.equal "example-key-name"
    response.instancesSet.item[1].instanceType.should.equal "m1.small"
    response.instancesSet.item[1].launchTime.should.equal "2007-08-07T11:51:50.000Z"

    response.instancesSet.item[2].instanceId.should.equal "i-2be64332"
    response.instancesSet.item[2].imageId.should.equal "ami-60a54009"
    response.instancesSet.item[2].instanceState.code.should.equal "0"
    response.instancesSet.item[2].instanceState.name.should.equal "pending"
    response.instancesSet.item[2].privateDnsName
    response.instancesSet.item[2].dnsName.should.be.nil
    response.instancesSet.item[2].keyName.should.equal "example-key-name"
    response.instancesSet.item[2].instanceType.should.equal "m1.small"
    response.instancesSet.item[2].launchTime.should.equal "2007-08-07T11:51:50.000Z"
  end


  specify "method 'run_instances' should reject invalid arguments" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "AddressingType" => 'public', 'InstanceType' => 'm1.small').
      returns stub(:body => @run_instances_response_body, :is_a? => true)

    lambda { @ec2.run_instances() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "" ) }.should.raise(EC2::ArgumentError)

    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1 ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 0 ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => "" ) }.should.raise(EC2::ArgumentError)

    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => 1 ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => 0 ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => "" ) }.should.raise(EC2::ArgumentError)

    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "public" ) }.should.not.raise(EC2::ArgumentError)
    #lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "direct" ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "foo" ) }.should.raise(EC2::ArgumentError)

    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => true ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => false ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => "" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => "foo" ) }.should.raise(EC2::ArgumentError)
  end


  specify "should be able specify an availability_zone" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "Placement.AvailabilityZone" => "zone123", "UserData" => "foo", "AddressingType" => 'public', 'InstanceType' => 'm1.small').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :availability_zone => "zone123", :group_id => [], :user_data => "foo", :base64_encoded => true ).should.be.an.instance_of Hash
  end

  specify "should be able to call run_instances with :user_data and :base64_encoded => true (default is false)" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "UserData" => "foo", "AddressingType" => 'public', 'InstanceType' => 'm1.small').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :group_id => [], :user_data => "foo", :base64_encoded => true ).should.be.an.instance_of Hash
  end

  specify "should be able specify an kernel_id" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "Placement.AvailabilityZone" => "zone123", "UserData" => "foo", "AddressingType" => 'public', 'InstanceType' => 'm1.small', 'KernelId' => 'kernfoo').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :availability_zone => "zone123", :group_id => [], :user_data => "foo", :base64_encoded => true, :kernel_id => 'kernfoo' ).should.be.an.instance_of Hash
  end

  specify "should be able to call run_instances with :user_data and :base64_encoded => false" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "UserData" => "Zm9v", "AddressingType" => 'public', 'InstanceType' => 'm1.small').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :group_id => [], :user_data => "foo", :base64_encoded => false ).should.be.an.instance_of Hash
  end


  specify "should be able to be described and return the correct Ruby response class" do
    @ec2.stubs(:make_request).with('DescribeInstances', {}).
      returns stub(:body => @describe_instances_response_body, :is_a? => true)
    @ec2.describe_instances.should.be.an.instance_of Hash
    response = @ec2.describe_instances
    response.reservationSet.item[0].reservationId.should.equal "r-44a5402d"
  end


  specify "should be able to be described with no params and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeInstances', {}).
      returns stub(:body => @describe_instances_response_body, :is_a? => true)
    @ec2.describe_instances.reservationSet.item.length.should.equal 1
    response = @ec2.describe_instances
    response.reservationSet.item[0].reservationId.should.equal "r-44a5402d"
    response.reservationSet.item[0].ownerId.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response.reservationSet.item[0].groupSet.item[0].groupId.should.equal "default"
    response.reservationSet.item[0].instancesSet.item[0].instanceId.should.equal "i-28a64341"
    response.reservationSet.item[0].instancesSet.item[0].imageId.should.equal "ami-6ea54007"
    response.reservationSet.item[0].instancesSet.item[0].instanceState.code.should.equal "0"
    response.reservationSet.item[0].instancesSet.item[0].instanceState.name.should.equal "running"
    response.reservationSet.item[0].instancesSet.item[0].privateDnsName.should.equal "domU-12-31-35-00-1E-01.z-2.compute-1.internal"
    response.reservationSet.item[0].instancesSet.item[0].dnsName.should.equal "ec2-72-44-33-4.z-2.compute-1.amazonaws.com"
    response.reservationSet.item[0].instancesSet.item[0].keyName.should.equal "example-key-name"
    response.reservationSet.item[0].instancesSet.item[0].productCodesSet.item[0].productCode.should.equal "774F4FF8"
  end


  specify "should be able to be described with params of Array of :instance_id's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeInstances', {"InstanceId.1" => "i-28a64341"}).
      returns stub(:body => @describe_instances_response_body, :is_a? => true)
    @ec2.describe_instances( :instance_id => "i-28a64341" ).reservationSet.item.length.should.equal 1
    response = @ec2.describe_instances( :instance_id => "i-28a64341" )
    response.reservationSet.item[0].reservationId.should.equal "r-44a5402d"
    response.reservationSet.item[0].ownerId.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response.reservationSet.item[0].groupSet.item[0].groupId.should.equal "default"
    response.reservationSet.item[0].instancesSet.item[0].instanceId.should.equal "i-28a64341"
    response.reservationSet.item[0].instancesSet.item[0].imageId.should.equal "ami-6ea54007"
    response.reservationSet.item[0].instancesSet.item[0].instanceState.code.should.equal "0"
    response.reservationSet.item[0].instancesSet.item[0].instanceState.name.should.equal "running"
    response.reservationSet.item[0].instancesSet.item[0].privateDnsName.should.equal "domU-12-31-35-00-1E-01.z-2.compute-1.internal"
    response.reservationSet.item[0].instancesSet.item[0].dnsName.should.equal "ec2-72-44-33-4.z-2.compute-1.amazonaws.com"
    response.reservationSet.item[0].instancesSet.item[0].keyName.should.equal "example-key-name"
    response.reservationSet.item[0].instancesSet.item[0].productCodesSet.item[0].productCode.should.equal "774F4FF8"
  end


  specify "method reboot_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.reboot_instances() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reboot_instances( :instance_id => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reboot_instances( :instance_id => "" ) }.should.raise(EC2::ArgumentError)
  end


  specify "should be able to be rebooted when provided with an :instance_id" do
    @ec2.expects(:make_request).with('RebootInstances', {"InstanceId.1"=>"i-2ea64347", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @reboot_instances_response_body, :is_a? => true)
    @ec2.reboot_instances( :instance_id => ["i-2ea64347", "i-21a64348"] ).class.should.equal Hash
  end


  specify "method terminate_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.terminate_instances() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.terminate_instances( :instance_id => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.terminate_instances( :instance_id => "" ) }.should.raise(EC2::ArgumentError)
  end


  specify "should be able to be terminated when provided with an :instance_id" do
    @ec2.stubs(:make_request).with('TerminateInstances', {"InstanceId.1"=>"i-28a64341", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @terminate_instances_response_body, :is_a? => true)
    @ec2.terminate_instances( :instance_id => ["i-28a64341", "i-21a64348"] ).class.should.equal Hash

    @response = @ec2.terminate_instances( :instance_id => ["i-28a64341", "i-21a64348"] )

    @response.instancesSet.item[0].instanceId.should.equal "i-28a64341"
    @response.instancesSet.item[0].shutdownState.code.should.equal "32"
    @response.instancesSet.item[0].shutdownState.name.should.equal "shutting-down"
    @response.instancesSet.item[0].previousState.code.should.equal "0"
    @response.instancesSet.item[0].previousState.name.should.equal "pending"

    @response.instancesSet.item[1].instanceId.should.equal "i-21a64348"
    @response.instancesSet.item[1].shutdownState.code.should.equal "32"
    @response.instancesSet.item[1].shutdownState.name.should.equal "shutting-down"
    @response.instancesSet.item[1].previousState.code.should.equal "0"
    @response.instancesSet.item[1].previousState.name.should.equal "pending"
  end

end
