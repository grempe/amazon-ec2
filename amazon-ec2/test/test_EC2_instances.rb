require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 instances " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new('not a key', 'not a secret')
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