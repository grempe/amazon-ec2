require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 instances " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )
    
    @run_instances_response_body = <<-RESPONSE
    <RunInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
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
          <privateDnsName/>
          <dnsName/>
          <keyName>example-key-name</keyName>
        </item>
        <item>
          <instanceId>i-2bc64242</instanceId>
          <imageId>ami-60a54009</imageId>
          <instanceState>
            <code>0</code>
            <name>pending</name>
          </instanceState>
          <privateDnsName/>
          <dnsName/>
          <keyName>example-key-name</keyName>
        </item>
        <item>
          <instanceId>i-2be64332</instanceId>
          <imageId>ami-60a54009</imageId>
          <instanceState>
            <code>0</code>
            <name>pending</name>
          </instanceState>
          <privateDnsName/>
          <dnsName/>
          <keyName>example-key-name</keyName>
        </item>
      </instancesSet>
    </RunInstancesResponse>
    RESPONSE
    
    @describe_instances_response_body = <<-RESPONSE
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
    
    @reboot_instances_response_body = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19">
      <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    
    @terminate_instances_response_body = <<-RESPONSE
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
  end
  
  
  specify "should be able to be run" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1').
      returns stub(:body => @run_instances_response_body, :is_a? => true)
      
    @ec2.run_instances( :image_id => "ami-60a54009" ).should.be.an.instance_of EC2::RunInstancesResponse
    
    response = @ec2.run_instances( :image_id => "ami-60a54009" )
    response.reservation_id.should.equal "r-47a5402e"
    response.owner_id.should.equal "495219933132"
    response.group_set[0].group_id.should.equal "default"
    
    response.instances_set.length.should.equal 3
    
    response.instances_set[0].instance_id.should.equal "i-2ba64342"
    response.instances_set[0].image_id.should.equal "ami-60a54009"
    response.instances_set[0].instance_state_code.should.equal "0"
    response.instances_set[0].instance_state_name.should.equal "pending"
    response.instances_set[0].private_dns_name.should.be.nil
    response.instances_set[0].dns_name.should.be.nil
    response.instances_set[0].key_name.should.equal "example-key-name"
    
    response.instances_set[1].instance_id.should.equal "i-2bc64242"
    response.instances_set[1].image_id.should.equal "ami-60a54009"
    response.instances_set[1].instance_state_code.should.equal "0"
    response.instances_set[1].instance_state_name.should.equal "pending"
    response.instances_set[1].private_dns_name.should.be.nil
    response.instances_set[1].dns_name.should.be.nil
    response.instances_set[1].key_name.should.equal "example-key-name"
    
    response.instances_set[2].instance_id.should.equal "i-2be64332"
    response.instances_set[2].image_id.should.equal "ami-60a54009"
    response.instances_set[2].instance_state_code.should.equal "0"
    response.instances_set[2].instance_state_name.should.equal "pending"
    response.instances_set[2].private_dns_name.should.be.nil
    response.instances_set[2].dns_name.should.be.nil
    response.instances_set[2].key_name.should.equal "example-key-name"
  end
  
  
  specify "method 'run_instances' should reject invalid arguments" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1').
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
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "direct" ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :addressing_type => "foo" ) }.should.raise(EC2::ArgumentError)
    
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => true ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => false ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => "" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.run_instances( :image_id => "ami-60a54009", :base64_encoded => "foo" ) }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "should be able to call run_instances with :user_data and :base64_encoded => true (default is false)" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "UserData" => "foo").
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :group_id => [], :user_data => "foo", :base64_encoded => true ).should.be.an.instance_of EC2::RunInstancesResponse
  end
  
  
  specify "should be able to call run_instances with :user_data and :base64_encoded => false" do
    @ec2.stubs(:make_request).with('RunInstances', "ImageId" => "ami-60a54009", "MinCount" => '1', "MaxCount" => '1', "UserData" => "Zm9v").
      returns stub(:body => @run_instances_response_body, :is_a? => true)
    @ec2.run_instances( :image_id => "ami-60a54009", :min_count => 1, :max_count => 1, :group_id => [], :user_data => "foo", :base64_encoded => false ).should.be.an.instance_of EC2::RunInstancesResponse
  end
  
  
  specify "should be able to be described and return the correct Ruby response class for parent and members" do
    @ec2.stubs(:make_request).with('DescribeInstances', {}).
      returns stub(:body => @describe_instances_response_body, :is_a? => true)
    @ec2.describe_instances.should.be.an.instance_of EC2::DescribeInstancesResponseSet
    response = @ec2.describe_instances
    response[0].should.be.an.instance_of EC2::Item
  end
  
  
  specify "should be able to be described with no params and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeInstances', {}).
      returns stub(:body => @describe_instances_response_body, :is_a? => true)
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
  
  
  specify "should be able to be described with params of Array of :instance_id's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeInstances', {"InstanceId.1" => "i-28a64341"}).
      returns stub(:body => @describe_instances_response_body, :is_a? => true)
    @ec2.describe_instances( :instance_id => "i-28a64341" ).length.should.equal 1
    response = @ec2.describe_instances( :instance_id => "i-28a64341" )
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
    lambda { @ec2.reboot_instances( :instance_id => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reboot_instances( :instance_id => "" ) }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "should be able to be rebooted when provided with an :instance_id" do
    @ec2.expects(:make_request).with('RebootInstances', {"InstanceId.1"=>"i-2ea64347", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @reboot_instances_response_body, :is_a? => true)
    @ec2.reboot_instances( :instance_id => ["i-2ea64347", "i-21a64348"] ).class.should.equal EC2::RebootInstancesResponse
  end
  
  
  specify "method terminate_instances should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.terminate_instances() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.terminate_instances( :instance_id => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.terminate_instances( :instance_id => "" ) }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "should be able to be terminated when provided with an :instance_id" do
    @ec2.stubs(:make_request).with('TerminateInstances', {"InstanceId.1"=>"i-28a64341", "InstanceId.2"=>"i-21a64348"}).
      returns stub(:body => @terminate_instances_response_body, :is_a? => true)
    @ec2.terminate_instances( :instance_id => ["i-28a64341", "i-21a64348"] ).class.should.equal EC2::TerminateInstancesResponseSet
    
    @response = @ec2.terminate_instances( :instance_id => ["i-28a64341", "i-21a64348"] )
    
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