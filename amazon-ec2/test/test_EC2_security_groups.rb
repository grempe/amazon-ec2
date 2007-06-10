require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 security groups " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )
    
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
    
    @describe_security_groups_response_body = <<-RESPONSE
    <DescribeSecurityGroupsResponse xm-lns="http://ec2.amazonaws.com/doc/2007-01-19">
      <securityGroupInfo>
        <item>
          <ownerId>UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM</ownerId>
          <groupName>WebServers</groupName>
          <groupDescription>Web</groupDescription>
          <ipPermissions>
            <item>
              <ipProtocol>tcp</ipProtocol>
              <fromPort>80</fromPort>
              <toPort>80</toPort>
              <groups/>
              <ipRanges>
                <item>
                  <cidrIp>0.0.0.0/0</cidrIp>
                </item>
              </ipRanges>
            </item>
          </ipPermissions>
        </item>
        <item>
          <ownerId>UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM</ownerId>
          <groupName>RangedPortsBySource</groupName>
          <groupDescription>A</groupDescription>
          <ipPermissions>
            <item>
              <ipProtocol>tcp</ipProtocol>
              <fromPort>6000</fromPort>
              <toPort>7000</toPort>
              <groups/>
              <ipRanges/>
            </item>
          </ipPermissions>
        </item>
      </securityGroupInfo>
    </DescribeSecurityGroupsResponse>
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
  
  
  specify "should be able to be described with describe_security_groups" do
    @ec2.stubs(:make_request).with('DescribeSecurityGroups', { "GroupName.1" => "WebServers", "GroupName.2" => "RangedPortsBySource" }).
      returns stub(:body => @describe_security_groups_response_body, :is_a? => true)
    @ec2.describe_security_groups( :group_name => ["WebServers", "RangedPortsBySource"] ).should.be.an.instance_of EC2::DescribeSecurityGroupsResponseSet
    
    response = @ec2.describe_security_groups( :group_name => ["WebServers", "RangedPortsBySource"] )
    response[0].owner_id.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response[0].group_name.should.equal "WebServers"
    response[0].group_description.should.equal "Web"
    response[0].ip_permissions[0].ip_protocol.should.equal "tcp"
    response[0].ip_permissions[0].from_port.should.equal "80"
    response[0].ip_permissions[0].to_port.should.equal "80"
    response[0].ip_permissions[0].groups.should.be.nil
    response[0].ip_permissions[0].ip_ranges[0].cidr_ip.should.equal "0.0.0.0/0"
    
    response[1].owner_id.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response[1].group_name.should.equal "RangedPortsBySource"
    response[1].group_description.should.equal "A"
    
    # debugging display of responses
    #puts "response[0] : " + response[0].inspect
    #puts "response[1] : " + response[1].inspect
    
    response[1].ip_permissions[0].ip_protocol.should.equal "tcp"
    response[1].ip_permissions[0].from_port.should.equal "6000"
    response[1].ip_permissions[0].to_port.should.equal "7000"
    response[1].ip_permissions[0].groups.should.be.nil
    response[1].ip_permissions[0].ip_ranges[0].should.be.nil
  end
  
  
  specify "method describe_security_groups should reject bad arguments" do
    @ec2.stubs(:make_request).with('DescribeSecurityGroups', {"GroupName.1"=>"WebServers"}).
      returns stub(:body => @describe_security_groups_response_body, :is_a? => true)
      
      lambda { @ec2.describe_security_groups( :group_name => "WebServers" ) }.should.not.raise(EC2::ArgumentError)
      
      # :group_name can't be nil or empty
      lambda { @ec2.describe_security_groups( :group_name => "" ) }.should.raise(EC2::ArgumentError)
      lambda { @ec2.describe_security_groups( :group_name => nil ) }.should.raise(EC2::ArgumentError)
  end
  
end
