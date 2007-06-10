require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 security groups " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new( :aws_access_key_id => "not a key", :aws_secret_access_key => "not a secret" )
    
    @create_security_group_response_body = <<-RESPONSE
    <CreateSecurityGroupResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
      <return>true</return> 
    </CreateSecurityGroupResponse>
    RESPONSE
    
    @delete_security_group_response_body = <<-RESPONSE
    <DeleteSecurityGroupResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
      <return>true</return> 
    </DeleteSecurityGroupResponse>
    RESPONSE
    
  end
  
  
  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('CreateSecurityGroup', {"GroupName"=>"WebServers", "GroupDescription"=>"Web"}).
      returns stub(:body => @create_security_group_response_body, :is_a? => true)
    @ec2.create_security_group( :group_name => "WebServers", :group_description => "Web" ).should.be.an.instance_of EC2::CreateSecurityGroupResponse
  end
  
  
  specify "method create_security_group should reject bad arguments" do
    @ec2.stubs(:make_request).with('CreateSecurityGroup', {"GroupName"=>"WebServers", "GroupDescription"=>"Web"}).
      returns stub(:body => @create_security_group_response_body, :is_a? => true)
    
    lambda { @ec2.create_security_group( :group_name => "WebServers", :group_description => "Web" ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.create_security_group() }.should.raise(EC2::ArgumentError)
    
    # :group_name can't be nil or empty
    lambda { @ec2.create_security_group( :group_name => "", :group_description => "Web" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_security_group( :group_name => nil, :group_description => "Web" ) }.should.raise(EC2::ArgumentError)
    
    # :group_description can't be nil or empty
    lambda { @ec2.create_security_group( :group_name => "WebServers", :group_description => "" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.create_security_group( :group_name => "WebServers", :group_description => nil ) }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "should be able to be deleted" do
    @ec2.stubs(:make_request).with('DeleteSecurityGroup', {"GroupName"=>"WebServers"}).
      returns stub(:body => @delete_security_group_response_body, :is_a? => true)
    @ec2.delete_security_group( :group_name => "WebServers" ).should.be.an.instance_of EC2::DeleteSecurityGroupResponse
  end
  
  
  specify "method delete_security_group should reject bad arguments" do
    @ec2.stubs(:make_request).with('DeleteSecurityGroup', {"GroupName"=>"WebServers"}).
      returns stub(:body => @delete_security_group_response_body, :is_a? => true)
    
    lambda { @ec2.delete_security_group( :group_name => "WebServers" ) }.should.not.raise(EC2::ArgumentError)
    lambda { @ec2.delete_security_group() }.should.raise(EC2::ArgumentError)
    
    # :group_name can't be nil or empty
    lambda { @ec2.delete_security_group( :group_name => "" ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.delete_security_group( :group_name => nil ) }.should.raise(EC2::ArgumentError)
    
  end
  
end
