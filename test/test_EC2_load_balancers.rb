require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 load balancers " do
  before do
    @ec2 = EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @valid_create_load_balancer_params = {
      :load_balancer_name => 'Test Name',
      :availability_zones => ['east-1a'],
      :listeners => [{:protocol => 'HTTP', :load_balancer_port => '80', :instance_port => '80'}]
    }
    
    @create_load_balancer_response_body = <<-RESPONSE
    <CreateLoadBalancerResult>
      <DNSName>TestLoadBalancer-380544827.us-east-1.elb.amazonaws.com</DNSName>
    </CreateLoadBalancerResult>
    RESPONSE
  end
  
  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('CreateLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'AvailabilityZones.member.1' => 'east-1a',
      'Listeners.member.1.Protocol' => 'HTTP',
      'Listeners.member.1.LoadBalancerPort' => '80',
      'Listeners.member.1.InstancePort' => '80'
    }).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)

    response = @ec2.create_load_balancer(@valid_create_load_balancer_params)
    response.should.be.an.instance_of Hash
    response.DNSName.should.equal "TestLoadBalancer-380544827.us-east-1.elb.amazonaws.com"
  end
  
  specify "method create_load_balancer should reject bad arguments" do
    @ec2.stubs(:make_request).with('CreateLoadBalancer', {
      'LoadBalancerName' => 'Test Name',
      'AvailabilityZones.member.1' => 'east-1a',
      'Listeners.member.1.Protocol' => 'HTTP',
      'Listeners.member.1.LoadBalancerPort' => '80',
      'Listeners.member.1.InstancePort' => '80'
    }).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params.merge(:load_balancer_name=>nil)) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params.merge(:load_balancer_name=>'')) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params.merge(:availability_zones=>'')) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params.merge(:availability_zones=>[])) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params.merge(:listeners=>[])) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_load_balancer(@valid_create_load_balancer_params.merge(:listeners=>nil)) }.should.raise(EC2::ArgumentError)
  end
end