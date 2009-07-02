require File.dirname(__FILE__) + '/test_helper.rb'

context "elb load balancers " do
  before do
    @elb = AWS::ELB::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @valid_create_load_balancer_params = {
      :load_balancer_name => 'Test Name',
      :availability_zones => ['east-1a'],
      :listeners => [{:protocol => 'HTTP', :load_balancer_port => '80', :instance_port => '80'}]
    }
    
    @create_load_balancer_response_body = <<-RESPONSE
    <CreateLoadBalancerResult>
      <DNSName>TestLoadBalancer-380544827.us-east-1.ec2.amazonaws.com</DNSName>
    </CreateLoadBalancerResult>
    RESPONSE
    
    @valid_delete_load_balancer_params = {
      :load_balancer_name => 'Test Name'
    }
    
    @delete_load_balancer_response_body = <<-RESPONSE
    <DeleteLoadBalancerResult>
      <return>true</return>
    </DeleteLoadBalancerResult>
    RESPONSE
    
    @valid_describe_load_balancer_params = {
    }
    
    @describe_load_balancer_response_body = <<-RESPONSE
    <DescribeLoadBalancersResponse xmlns="http://elasticloadbalancing.amazonaws.com/doc/2009-05-15/">
      <DescribeLoadBalancersResult>
        <LoadBalancerDescriptions>
          <member>
            <Listeners>
              <member>
                <Protocol>HTTP</Protocol>
                <LoadBalancerPort>80</LoadBalancerPort>
                <InstancePort>80</InstancePort>
              </member>
            </Listeners>
            <CreatedTime>2009-07-02T01:07:55.080Z</CreatedTime>
            <LoadBalancerName>TestLB</LoadBalancerName>
            <DNSName>TestLB-1459724896.us-east-1.elb.amazonaws.com</DNSName>
            <HealthCheck>
              <Interval>30</Interval>
              <Target>TCP:80</Target>
              <HealthyThreshold>10</HealthyThreshold>
              <Timeout>5</Timeout>
              <UnhealthyThreshold>2</UnhealthyThreshold>
            </HealthCheck>
            <Instances/>
            <AvailabilityZones>
              <member>us-east-1a</member>
            </AvailabilityZones>
          </member>
        </LoadBalancerDescriptions>
      </DescribeLoadBalancersResult>
      <ResponseMetadata>
        <RequestId>67dd800e-66a5-11de-b844-07deabfcc881</RequestId>
      </ResponseMetadata>
    </DescribeLoadBalancersResponse>
    RESPONSE
  end
  
  specify "should be able to be created" do
    @elb.stubs(:make_request).with('CreateLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'AvailabilityZones.member.1' => 'east-1a',
      'Listeners.member.1.Protocol' => 'HTTP',
      'Listeners.member.1.LoadBalancerPort' => '80',
      'Listeners.member.1.InstancePort' => '80'
    }).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)

    response = @elb.create_load_balancer(@valid_create_load_balancer_params)
    response.should.be.an.instance_of Hash
    response.DNSName.should.equal "TestLoadBalancer-380544827.us-east-1.ec2.amazonaws.com"
  end
  
  specify "method create_load_balancer should reject bad arguments" do
    @elb.stubs(:make_request).with('CreateLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'AvailabilityZones.member.1' => 'east-1a',
      'Listeners.member.1.Protocol' => 'HTTP',
      'Listeners.member.1.LoadBalancerPort' => '80',
      'Listeners.member.1.InstancePort' => '80'
    }).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params) }.should.not.raise(AWS::ArgumentError)
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params.merge(:load_balancer_name=>nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params.merge(:load_balancer_name=>'')) }.should.raise(AWS::ArgumentError)
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params.merge(:availability_zones=>'')) }.should.raise(AWS::ArgumentError)
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params.merge(:availability_zones=>[])) }.should.raise(AWS::ArgumentError)
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params.merge(:listeners=>[])) }.should.raise(AWS::ArgumentError)
    lambda { @elb.create_load_balancer(@valid_create_load_balancer_params.merge(:listeners=>nil)) }.should.raise(AWS::ArgumentError)
  end
  
  specify "should be able to be deleted with delete_load_balancer" do
    @elb.stubs(:make_request).with('DeleteLoadBalancer', {'LoadBalancerName' => 'Test Name'}).
      returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)
      
    response = @elb.delete_load_balancer( :load_balancer_name => "Test Name" )
    response.should.be.an.instance_of Hash
    response.return.should.equal "true"
  end
  
  specify "should be able to be described with describe_load_balancer" do
    @elb.stubs(:make_request).with('DescribeLoadBalancers', {}).
      returns stub(:body => @describe_load_balancer_response_body, :is_a? => true)

    response = @elb.describe_load_balancers()
    response.should.be.an.instance_of Hash
    
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions.member.length.should == 1
  end
end
