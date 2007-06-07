require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 instances " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new('not a key', 'not a secret')
  end
  
  
  specify "should be able to be described and return the correct Ruby response class for parent and members" do
    body = <<-RESPONSE
    <DescribeInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
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
            </item>
          </instancesSet>
        </item>
      </reservationSet>
    </DescribeInstancesResponse>
    RESPONSE
    
    @ec2.stubs(:make_request).with('DescribeInstances', {}).
      returns stub(:body => body, :is_a? => true)
    @ec2.describe_instances.should.be.an.instance_of EC2::DescribeInstancesResponseSet
    response = @ec2.describe_instances
    response[0].should.be.an.instance_of EC2::Item
  end

  specify "should be able to be described with no params and return an array of Items" do
    body = <<-RESPONSE
    <DescribeInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
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
            </item>
          </instancesSet>
        </item>
      </reservationSet>
    </DescribeInstancesResponse>
    RESPONSE
    
    @ec2.stubs(:make_request).with('DescribeInstances', {}).
      returns stub(:body => body, :is_a? => true)
    @ec2.describe_instances.length.should.equal 1
    response = @ec2.describe_instances
    response[0].reservation_id.should.equal "r-44a5402d"
    response[0].owner_id.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response[0].group_set[0].group_id.should.equal "default"
    response[0].instances_set[0].instance_id.should.equal "i-28a64341"
    response[0].instances_set[0].image_id.should.equal "ami-6ea54007"
    response[0].instances_set[0].instance_state_code.should.equal "0"
    response[0].instances_set[0].instance_state_name.should.equal "running"
    response[0].instances_set[0].private_dns_name.should.equal "domU-12-31-35-00-1E-01.z-2.compute-1.internal"
    response[0].instances_set[0].dns_name.should.equal "ec2-72-44-33-4.z-2.compute-1.amazonaws.com"
    response[0].instances_set[0].key_name.should.equal "example-key-name"
  end
  
  
  specify "should be able to be described with params of Array of instanceIds and return an array of Items" do
    body = <<-RESPONSE
    <DescribeInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
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
            </item>
          </instancesSet>
        </item>
      </reservationSet>
    </DescribeInstancesResponse>
    RESPONSE
    
    @ec2.stubs(:make_request).with('DescribeInstances', {"InstanceId.1" => "i-28a64341"}).
      returns stub(:body => body, :is_a? => true)
    @ec2.describe_instances(["i-28a64341"]).length.should.equal 1
    response = @ec2.describe_instances(["i-28a64341"])
    response[0].reservation_id.should.equal "r-44a5402d"
    response[0].owner_id.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response[0].group_set[0].group_id.should.equal "default"
    response[0].instances_set[0].instance_id.should.equal "i-28a64341"
    response[0].instances_set[0].image_id.should.equal "ami-6ea54007"
    response[0].instances_set[0].instance_state_code.should.equal "0"
    response[0].instances_set[0].instance_state_name.should.equal "running"
    response[0].instances_set[0].private_dns_name.should.equal "domU-12-31-35-00-1E-01.z-2.compute-1.internal"
    response[0].instances_set[0].dns_name.should.equal "ec2-72-44-33-4.z-2.compute-1.amazonaws.com"
    response[0].instances_set[0].key_name.should.equal "example-key-name"
  end
  
  
  specify "method reboot_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.reboot_instances() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reboot_instances("") }.should.raise(EC2::ArgumentError)
  end
  
  specify "should be able to be rebooted when provided with an instance ID" do
    body = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
      <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    
    @ec2.expects(:make_request).with('RebootInstances', {"InstanceId.1"=>"i-2ea64347", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => body, :is_a? => true)
    @ec2.reboot_instances(["i-2ea64347", "i-21a64348"]).class.should.equal EC2::RebootInstancesResponse
  end
  
  
  specify "method terminate_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.terminate_instances() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.terminate_instances("") }.should.raise(EC2::ArgumentError)
  end
  
  specify "should be able to be terminated when provided with an instance ID" do
    body = <<-RESPONSE
    <TerminateInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
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
    
    @ec2.stubs(:make_request).with('TerminateInstances', {"InstanceId.1"=>"i-28a64341", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => body, :is_a? => true)
    @ec2.terminate_instances(["i-28a64341", "i-21a64348"]).class.should.equal EC2::TerminateInstancesResponseSet
    
    @response = @ec2.terminate_instances(["i-28a64341", "i-21a64348"])
    
    @response[0].instance_id.should.equal "i-28a64341"
    @response[0].shutdown_state_code.should.equal "32"
    @response[0].shutdown_state_name.should.equal "shutting-down"
    @response[0].previous_state_code.should.equal "0"
    @response[0].previous_state_name.should.equal "pending"
    
    @response[1].instance_id.should.equal "i-21a64348"
    @response[1].shutdown_state_code.should.equal "32"
    @response[1].shutdown_state_name.should.equal "shutting-down"
    @response[1].previous_state_code.should.equal "0"
    @response[1].previous_state_name.should.equal "pending"
    
  end
  
end