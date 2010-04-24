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

    @valid_register_instances_with_load_balancer_params = {
      :load_balancer_name => 'Test Name',
      :instances => ['i-6055fa09']
    }

    @register_instances_with_load_balancer_response_body = <<-RESPONSE
    <RegisterInstancesWithLoadBalancerResult>
    	    <Instances>
    		      <member>
    			        <InstanceId>i-6055fa09</InstanceId>
    		      </member>
    	    </Instances>
    </RegisterInstancesWithLoadBalancerResult>
    RESPONSE

    @valid_deregister_instances_from_load_balancer_params = @valid_register_instances_with_load_balancer_params
    @deregister_instances_from_load_balancer_response_body = <<-RESPONSE
    <DeregisterInstancesFromLoadBalancerResult>
    	<Instances/>
    </DeregisterInstancesFromLoadBalancerResult>
    RESPONSE

    @valid_configure_health_check_params = {
      :load_balancer_name => 'Test Name',
      :health_check => {
        :target   => 'HTTP:80/servlets-examples/servlet/',
        :timeout  => '2',
        :interval => '5',
        :unhealthy_threshold => '2',
        :healthy_threshold   =>  '2'
      }
    }
    @configure_health_check_response_body = <<-RESPONSE
    <ConfigureHealthCheckResult>
    	<HealthCheck>
    		<Interval>5</Interval>
    		<Target>HTTP:80/servlets-examples/servlet/</Target>
    		<HealthyThreshold>2</HealthyThreshold>
    		<Timeout>2</Timeout>
    		<UnhealthyThreshold>2</UnhealthyThreshold>
    	</HealthCheck>
    </ConfigureHealthCheckResult>
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

  specify "should be able to be register instances to load balancers with register_instances_with_load_balancer" do
    @elb.stubs(:make_request).with('RegisterInstancesWithLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'Instances.member.1.InstanceId' => 'i-6055fa09'
    }).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)

    response = @elb.register_instances_with_load_balancer(@valid_register_instances_with_load_balancer_params)
    response.should.be.an.instance_of Hash

    response.Instances.member.length.should == 1
  end

  specify "method register_instances_with_load_balancer should reject bad arguments" do
    @elb.stubs(:make_request).with('RegisterInstancesWithLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'Instances.member.1.InstanceId' => 'i-6055fa09'
    }).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)

    lambda { @elb.register_instances_with_load_balancer(@valid_register_instances_with_load_balancer_params) }.should.not.raise(AWS::ArgumentError)
    lambda { @elb.register_instances_with_load_balancer(@valid_register_instances_with_load_balancer_params.merge(:load_balancer_name=>nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.register_instances_with_load_balancer(@valid_register_instances_with_load_balancer_params.merge(:instances=>nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.register_instances_with_load_balancer(@valid_register_instances_with_load_balancer_params.merge(:instances=>[])) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to deregister instances from load balancers with deregister_instances_from_load_balancer" do
    @elb.stubs(:make_request).with('DeregisterInstancesFromLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'Instances.member.1.InstanceId' => 'i-6055fa09'
     }).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)

     response = @elb.deregister_instances_from_load_balancer(@valid_deregister_instances_from_load_balancer_params)
     response.should.be.an.instance_of Hash
  end

  specify "method deregister_instances_from_load_balancer should reject bad arguments" do
    @elb.stubs(:make_request).with('DeregisterInstancesFromLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'Instances.member.1.InstanceId' => 'i-6055fa09'
    }).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)

    lambda { @elb.deregister_instances_from_load_balancer(@valid_deregister_instances_from_load_balancer_params) }.should.not.raise(AWS::ArgumentError)
    lambda { @elb.deregister_instances_from_load_balancer(@valid_deregister_instances_from_load_balancer_params.merge(:load_balancer_name=>nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.deregister_instances_from_load_balancer(@valid_deregister_instances_from_load_balancer_params.merge(:instances=>nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.deregister_instances_from_load_balancer(@valid_deregister_instances_from_load_balancer_params.merge(:instances=>[])) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to configure_health_check for instances from load balancers" do
    @elb.stubs(:make_request).with('ConfigureHealthCheck', {
      'LoadBalancerName' => 'Test Name',
      'HealthCheck.Interval' => '5',
      'HealthCheck.Target' => 'HTTP:80/servlets-examples/servlet/',
      'HealthCheck.HealthyThreshold' => '2',
      'HealthCheck.Timeout' => '2',
      'HealthCheck.UnhealthyThreshold' => '2'
    }).returns stub(:body => @configure_health_check_response_body, :is_a? => true)

    response = @elb.configure_health_check(@valid_configure_health_check_params)
    response.should.be.an.instance_of Hash

    lambda { @elb.configure_health_check(@valid_configure_health_check_params) }.should.not.raise(AWS::ArgumentError)
    lambda { @elb.configure_health_check(@valid_configure_health_check_params.merge(:load_balancer_name => nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.configure_health_check(@valid_configure_health_check_params.merge(:load_balancer_name => "")) }.should.raise(AWS::ArgumentError)

    lambda { @elb.configure_health_check(@valid_configure_health_check_params.merge(:health_check => nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.configure_health_check(@valid_configure_health_check_params.merge(:health_check => "")) }.should.raise(AWS::ArgumentError)

  end

  specify "should be able to configure_health_check for instances from load balancers with string health check args" do
    @elb.stubs(:make_request).with('ConfigureHealthCheck', {
      'LoadBalancerName' => 'Test Name',
      'HealthCheck.Interval' => '5',
      'HealthCheck.Target' => 'HTTP:80/servlets-examples/servlet/',
      'HealthCheck.HealthyThreshold' => '2',
      'HealthCheck.Timeout' => '2',
      'HealthCheck.UnhealthyThreshold' => '2'
    }).returns stub(:body => @configure_health_check_response_body, :is_a? => true)

    response = @elb.configure_health_check(@valid_configure_health_check_params.merge(:health_check => {:target => 'HTTP:80/servlets-examples/servlet/', :timeout => '2', :interval  => '5', :unhealthy_threshold  => '2', :healthy_threshold  => '2' }))
    response.should.be.an.instance_of Hash
  end

  specify "should be able to configure_health_check for instances from load balancers with FixNum health check args" do
    @elb.stubs(:make_request).with('ConfigureHealthCheck', {
      'LoadBalancerName' => 'Test Name',
      'HealthCheck.Interval' => '5',
      'HealthCheck.Target' => 'HTTP:80/servlets-examples/servlet/',
      'HealthCheck.HealthyThreshold' => '2',
      'HealthCheck.Timeout' => '2',
      'HealthCheck.UnhealthyThreshold' => '2'
    }).returns stub(:body => @configure_health_check_response_body, :is_a? => true)

    response = @elb.configure_health_check(@valid_configure_health_check_params.merge(:health_check => {:target => 'HTTP:80/servlets-examples/servlet/', :timeout => 2, :interval  => 5, :unhealthy_threshold  => 2, :healthy_threshold  => 2 }))
    response.should.be.an.instance_of Hash
  end


  specify "method degregister_instances_from_load_balancer should reject bad arguments" do
   @elb.stubs(:make_request).with('ConfigureHealthCheck', {
      'LoadBalancerName' => 'Test Name',
      'HealthCheck.Interval' => '5',
      'HealthCheck.Target' => 'HTTP:80/servlets-examples/servlet/',
      'HealthCheck.HealthyThreshold' => '2',
      'HealthCheck.Timeout' => '2',
      'HealthCheck.UnhealthyThreshold' => '2'
    }).returns stub(:body => @configure_health_check_response_body, :is_a? => true)

    lambda { @elb.configure_health_check(@valid_configure_health_check_params) }.should.not.raise(AWS::ArgumentError)
    lambda { @elb.configure_health_check(@valid_configure_health_check_params.merge(:load_balancer_name=>nil)) }.should.raise(AWS::ArgumentError)
    lambda { @elb.configure_health_check(@valid_configure_health_check_params.merge(:health_check=>nil)) }.should.raise(AWS::ArgumentError)
  end

end

