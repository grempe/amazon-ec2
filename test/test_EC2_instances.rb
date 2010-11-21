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

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

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

    @start_instances_response_body = <<-RESPONSE
    <StartInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2009-10-31/">
      <instancesSet>
        <item>
          <instanceId>i-10a64379</instanceId>
          <currentState>
              <code>0</code>
              <name>pending</name>
          </currentState>
          <previousState>
              <code>80</code>
              <name>stopped</name>
          </previousState>
        </item>
      </instancesSet>
    </StartInstancesResponse>
    RESPONSE


    @stop_instances_response_body = <<-RESPONSE
    <StopInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2009-10-31/">
      <instancesSet>
        <item>
          <instanceId>i-28a64341</instanceId>
          <currentState>
              <code>64</code>
              <name>stopping</name>
          </currentState>
          <previousState>
              <code>16</code>
              <name>running</name>
          </previousState>
        </item>
      </instancesSet>
    </StopInstancesResponse>
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

    @monitor_instances_response_body = <<-RESPONSE
    <MonitorInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2009-07-15/">
        <requestId>fe62a64c-49fb-4a3c-8d9b-61aba146d390</requestId>
        <instancesSet>
            <item>
                <instanceId>i-138fc47a</instanceId>
                <monitoring>
                    <state>pending</state>
                </monitoring>
            </item>
            <item>
                <instanceId>i-33457a5a</instanceId>
                <monitoring>
                    <state>pending</state>
                </monitoring>
            </item>
        </instancesSet>
    </MonitorInstancesResponse>
    RESPONSE

    @unmonitor_instances_response_body = <<-RESPONSE
    <UnmonitorInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2009-07-15/">
        <requestId>7dbc5095-f3ae-46d8-a5b1-19df118ceb05</requestId>
        <instancesSet>
            <item>
                <instanceId>i-138fc47a</instanceId>
                <monitoring>
                    <state>disabling</state>
                </monitoring>
            </item>
            <item>
                <instanceId>i-33457a5a</instanceId>
                <monitoring>
                    <state>disabling</state>
                </monitoring>
            </item>
        </instancesSet>
    </UnmonitorInstancesResponse>

    RESPONSE

    @describe_instance_attribute_response_body = <<-RESPONSE
    <DescribeInstanceAttributeResponse xmlns="http://ec2.amazonaws.com/doc/2010-08-31/">
      <instanceId>i-10a64379</instanceId>
      <kernel>
        <value>aki-f70657b2</value>
      </kernel>
    </DescribeInstanceAttributeResponse>
    RESPONSE

    @modify_instance_attribute_response_body = <<-RESPONSE
    <ModifyInstanceAttributeResponse xmlns="http://ec2.amazonaws.com/doc/2010-08-31/">
      <return>true</return>
    </ModifyInstanceAttributeResponse>
    RESPONSE

    @reset_instance_attribute_response_body = <<-RESPONSE
    <ResetInstanceAttributeResponse xmlns="http://ec2.amazonaws.com/doc/2010-08-31/">
      <return>true</return>
    </ResetInstanceAttributeResponse>
    RESPONSE
  end


  specify "should be able to be run" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1').
      returns stub(:body => @run_instances_response_body, :is_a? => true)

    @ec2.run_instances( :image_id => "ami-60a54009" ).should.be.an.instance_of Hash

    response = @ec2.run_instances( :image_id => "ami-60a54009" )

    response.reservationId.should.equal "r-47a5402e"
    response.ownerId.should.equal "495219933132"

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
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1').
      returns stub(:body => @run_instances_response_body, :is_a? => true)

    lambda { @ec2.run_instances() }.should.raise(AWS::ArgumentError)

    # :addressing_type is deprecated
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => nil ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "foo" ) }.should.raise(AWS::ArgumentError)

    # :group_id is deprecated
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :group_id => nil ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :group_id => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :group_id => "foo" ) }.should.raise(AWS::ArgumentError)

    # :image_id
    lambda { @ec2.run_instances( :image_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "" ) }.should.raise(AWS::ArgumentError)

    # :min_count
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1 ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 0 ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => "foo" ) }.should.raise(AWS::ArgumentError)

    # :max_count
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => 1 ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => 0 ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :max_count => "foo" ) }.should.raise(AWS::ArgumentError)

    # :min_count & :max_count
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1 ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 2, :max_count => 1 ) }.should.raise(AWS::ArgumentError)

    # :instance_type

    ["t1.micro", "m1.small", "m1.large", "m1.xlarge", "m2.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge", "cc1.4xlarge"].each do |type|
      @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "InstanceType" => type).
        returns stub(:body => @run_instances_response_body, :is_a? => true)
      lambda { @ec2.run_instances( :image_id => "ami-60a54009", :instance_type => type ) }.should.not.raise(AWS::ArgumentError)
    end

    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :instance_type => "m1.notarealsize" ) }.should.raise(AWS::ArgumentError)

    # :monitoring_enabled
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "Monitoring.Enabled" => 'true').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :monitoring_enabled => true ) }.should.not.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "Monitoring.Enabled" => 'false').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :monitoring_enabled => false ) }.should.not.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "Monitoring.Enabled" => 'false').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :monitoring_enabled => "foo" ) }.should.raise(AWS::ArgumentError)

    # :disable_api_termination
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "DisableApiTermination" => 'true').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :disable_api_termination => true ) }.should.not.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "DisableApiTermination" => 'false').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :disable_api_termination => false ) }.should.not.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "DisableApiTermination" => 'false').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :disable_api_termination => "foo" ) }.should.raise(AWS::ArgumentError)

    # :instance_initiated_shutdown_behavior
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "InstanceInitiatedShutdownBehavior" => 'stop').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :instance_initiated_shutdown_behavior => 'stop' ) }.should.not.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "InstanceInitiatedShutdownBehavior" => 'terminate').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :instance_initiated_shutdown_behavior => 'terminate' ) }.should.not.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "InstanceInitiatedShutdownBehavior" => 'stop').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :instance_initiated_shutdown_behavior => "foo" ) }.should.raise(AWS::ArgumentError)

    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "InstanceInitiatedShutdownBehavior" => 'stop').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :instance_initiated_shutdown_behavior => true ) }.should.raise(AWS::ArgumentError)

    # :base64_encoded
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => true ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => false ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => "foo" ) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able specify a key_name" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "KeyName" => 'foo').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :key_name => "foo" ).should.be.an.instance_of Hash
  end

  specify "should be able specify a security_group" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "SecurityGroup.1" => 'foo', "SecurityGroup.2" => 'bar').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :security_group => ["foo","bar"] ).should.be.an.instance_of Hash
  end

  specify "should be able specify additional_info" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "AdditionalInfo" => 'foo').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :additional_info => "foo" ).should.be.an.instance_of Hash
  end

  specify "should be able to call run_instances with :user_data and :base64_encoded => true (default is false)" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "UserData" => "Zm9v").
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :user_data => "foo", :base64_encoded => true ).should.be.an.instance_of Hash
  end

  specify "should be able to call run_instances with :user_data and :base64_encoded => false" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "UserData" => "foo").
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :user_data => "foo", :base64_encoded => false ).should.be.an.instance_of Hash
  end

  specify "should be able specify instance_type" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "InstanceType" => 'm1.small').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :instance_type => "m1.small" ).should.be.an.instance_of Hash
  end

  specify "should be able specify an availability_zone (Placement.AvailabilityZone)" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "Placement.AvailabilityZone" => "zone123").
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :availability_zone => "zone123" ).should.be.an.instance_of Hash
  end

  specify "should be able specify an kernel_id" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'KernelId' => 'kernfoo').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :kernel_id => 'kernfoo' ).should.be.an.instance_of Hash
  end

  specify "should be able specify an ramdisk_id" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'RamdiskId' => 'foo').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :ramdisk_id => 'foo' ).should.be.an.instance_of Hash
  end

  specify "should be able specify monitoring_enabled" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'Monitoring.Enabled' => 'true').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :monitoring_enabled => true ).should.be.an.instance_of Hash
  end

  specify "should be able specify an subnet_id" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'SubnetId' => 'foo').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :subnet_id => 'foo' ).should.be.an.instance_of Hash
  end

  specify "should be able specify disable_api_termination" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'DisableApiTermination' => 'true').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :disable_api_termination => true ).should.be.an.instance_of Hash
  end

  specify "should be able specify instance_initiated_shutdown_behavior" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'InstanceInitiatedShutdownBehavior' => 'stop').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :instance_initiated_shutdown_behavior => 'stop' ).should.be.an.instance_of Hash
  end

  specify "should be able specify block_device_mapping" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', 'BlockDeviceMapping.1.DeviceName' => '/dev/sdh', 'BlockDeviceMapping.1.VirtualName' => 'foo', 'BlockDeviceMapping.1.Ebs.SnapshotId' => 'foosnap', 'BlockDeviceMapping.1.Ebs.VolumeSize' => 'foovolsize', 'BlockDeviceMapping.1.Ebs.DeleteOnTermination' => 'true', 'BlockDeviceMapping.2.DeviceName' => '/dev/sdi', 'BlockDeviceMapping.2.VirtualName' => 'foo2', 'BlockDeviceMapping.2.Ebs.SnapshotId' => 'foosnap2', 'BlockDeviceMapping.2.Ebs.VolumeSize' => 'foovolsize2', 'BlockDeviceMapping.2.Ebs.DeleteOnTermination' => 'false').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :block_device_mapping => [{:device_name => '/dev/sdh', :virtual_name => 'foo', :ebs_snapshot_id => 'foosnap', :ebs_volume_size => 'foovolsize', :ebs_delete_on_termination => true},{:device_name => '/dev/sdi', :virtual_name => 'foo2', :ebs_snapshot_id => 'foosnap2', :ebs_volume_size => 'foovolsize2', :ebs_delete_on_termination => false}] ).should.be.an.instance_of Hash
  end

  specify "should get no user data for when options has no user_data key" do
    @ec2.extract_user_data({}).should == nil
  end

  specify "should get plain string user data when options has user_data and no base64 key" do
    @ec2.extract_user_data({:user_data => "foo\nbar"}).should == "foo\nbar"
  end

  specify "should strip new lines and base64 encode when options has both user_data and base64" do
    @ec2.extract_user_data({:user_data => "binary\ndata\nhere\n", :base64_encoded => true}).should == "YmluYXJ5CmRhdGEKaGVyZQo="
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
    lambda { @ec2.reboot_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reboot_instances( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reboot_instances( :instance_id => "" ) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be rebooted when provided with an :instance_id" do
    @ec2.expects(:make_request).with('RebootInstances', {"InstanceId.1"=>"i-2ea64347", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @reboot_instances_response_body, :is_a? => true)
    @ec2.reboot_instances( :instance_id => ["i-2ea64347", "i-21a64348"] ).class.should.equal Hash
  end


  specify "method start_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.start_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.start_instances( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.start_instances( :instance_id => "" ) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be started when provided with an :instance_id" do
    @ec2.stubs(:make_request).with('StartInstances', {"InstanceId.1"=>"i-28a64341", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @start_instances_response_body, :is_a? => true)
    @ec2.start_instances( :instance_id => ["i-28a64341", "i-21a64348"] ).class.should.equal Hash
  end


  specify "method stop_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.stop_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.stop_instances( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.stop_instances( :instance_id => "" ) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to be stopped when provided with an :instance_id" do
    @ec2.stubs(:make_request).with('StopInstances', {"InstanceId.1"=>"i-28a64341", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @stop_instances_response_body, :is_a? => true)
    @ec2.stop_instances( :instance_id => ["i-28a64341", "i-21a64348"] ).class.should.equal Hash
  end

  specify "method terminate_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.terminate_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.terminate_instances( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.terminate_instances( :instance_id => "" ) }.should.raise(AWS::ArgumentError)
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

  specify "method monitor_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.monitor_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.monitor_instances( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.monitor_instances( :instance_id => "" ) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to be monitored when provided with an :instance_id" do
    @ec2.stubs(:make_request).with('MonitorInstances', {"InstanceId.1"=>"i-138fc47a", "InstanceId.2"=>"i-33457a5a"}).
      returns stub(:body => @monitor_instances_response_body, :is_a? => true)
    @ec2.monitor_instances( :instance_id => ["i-138fc47a", "i-33457a5a"] ).class.should.equal Hash

    @response = @ec2.monitor_instances( :instance_id => ["i-138fc47a", "i-33457a5a"] )

    @response.instancesSet.item[0].instanceId.should.equal "i-138fc47a"
    @response.instancesSet.item[0].monitoring.state.should.equal "pending"

    @response.instancesSet.item[1].instanceId.should.equal "i-33457a5a"
    @response.instancesSet.item[1].monitoring.state.should.equal "pending"
  end

  specify "method unmonitor_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.unmonitor_instances() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.unmonitor_instances( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.unmonitor_instances( :instance_id => "" ) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to be unmonitored when provided with an :instance_id" do
    @ec2.stubs(:make_request).with('UnmonitorInstances', {"InstanceId.1"=>"i-138fc47a", "InstanceId.2"=>"i-33457a5a"}).
      returns stub(:body => @unmonitor_instances_response_body, :is_a? => true)
    @ec2.unmonitor_instances( :instance_id => ["i-138fc47a", "i-33457a5a"] ).class.should.equal Hash

    @response = @ec2.unmonitor_instances( :instance_id => ["i-138fc47a", "i-33457a5a"] )

    @response.instancesSet.item[0].instanceId.should.equal "i-138fc47a"
    @response.instancesSet.item[0].monitoring.state.should.equal "disabling"

    @response.instancesSet.item[1].instanceId.should.equal "i-33457a5a"
    @response.instancesSet.item[1].monitoring.state.should.equal "disabling"
  end

  specify "should get an ArgumentError when trying to describe/modify/reset an instance attribute without an istance id" do
    lambda { @ec2.describe_instance_attribute(:attribute => "ramdisk") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:attribute => "ramdisk") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:attribute => "ramdisk") }.should.raise(AWS::ArgumentError)

    lambda { @ec2.describe_instance_attribute(:attribute => "ramdisk", :instance_id => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:attribute => "ramdisk", :instance_id => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:attribute => "ramdisk", :instance_id => nil) }.should.raise(AWS::ArgumentError)

    lambda { @ec2.describe_instance_attribute(:attribute => "ramdisk", :instance_id => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:attribute => "ramdisk", :instance_id => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:attribute => "ramdisk", :instance_id => "") }.should.raise(AWS::ArgumentError)
  end

  specify "should get an ArgumentError when trying to describe/modify/reset an instance attribute without an attribute" do
    lambda { @ec2.describe_instance_attribute(:instance_id => "i-33457a5a") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:instance_id => "i-33457a5a") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:instance_id => "i-33457a5a") }.should.raise(AWS::ArgumentError)

    lambda { @ec2.describe_instance_attribute(:instance_id => "i-33457a5a", :attribute => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:instance_id => "i-33457a5a", :attribute => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:instance_id => "i-33457a5a", :attribute => nil) }.should.raise(AWS::ArgumentError)

    lambda { @ec2.describe_instance_attribute(:instance_id => "i-33457a5a", :attribute => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:instance_id => "i-33457a5a", :attribute => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:instance_id => "i-33457a5a", :attribute => "") }.should.raise(AWS::ArgumentError)
  end

  specify "should get an ArgumentError when trying to describe/modify/reset an instance attribute without a valid attribute" do
    lambda { @ec2.describe_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'party') }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'party') }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'party') }.should.raise(AWS::ArgumentError)
  end

  specify "should not get an ArgumentError when trying to describe/modify/reset an instance attribute with a valid attribute" do
    @ec2.stubs(:make_request).returns stub(:body => @describe_instance_attribute_response_body, :is_a? => true)
    %w(instanceType kernel ramdisk userData disableApiTermination instanceInitiatedShutdownBehavior rootDevice blockDeviceMapping).each do |a|
      lambda { @ec2.describe_instance_attribute(:instance_id => "i-33457a5a", :attribute => a) }.should.not.raise(AWS::ArgumentError)
      lambda { @ec2.modify_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'party') }.should.raise(AWS::ArgumentError)
    end
    %w(kernel ramdisk).each do |a|
      lambda { @ec2.reset_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'party') }.should.raise(AWS::ArgumentError)
    end
  end

  specify "should successfully describe instance attribute" do
    @ec2.stubs(:make_request).with('DescribeInstanceAttribute', {"InstanceId"=>"i-33457a5a", "Attribute" => "kernel"}).
      returns stub(:body => @describe_instance_attribute_response_body, :is_a? => true)
    @response = @ec2.describe_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'kernel')
    @response.class.should.equal Hash
    @response.kernel.value.should.equal "aki-f70657b2"
  end

  specify "should successfully modify instance attribute" do
    @ec2.stubs(:make_request).with('ModifyInstanceAttribute', {"InstanceId"=>"i-33457a5a", "Attribute" => "disableApiTermination", "Value" => "true"}).
      returns stub(:body => @modify_instance_attribute_response_body, :is_a? => true)
    @response = @ec2.modify_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'disableApiTermination', :value => true)
    @response.class.should.equal Hash
    @response.return.should.equal "true"
  end

  specify "should successfully reset instance attribute" do
    @ec2.stubs(:make_request).with('ResetInstanceAttribute', {"InstanceId"=>"i-33457a5a", "Attribute" => "kernel"}).
      returns stub(:body => @reset_instance_attribute_response_body, :is_a? => true)
    @response = @ec2.reset_instance_attribute(:instance_id => "i-33457a5a", :attribute => 'kernel')
    @response.class.should.equal Hash
    @response.return.should.equal "true"
  end
end
