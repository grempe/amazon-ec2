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

context "EC2 security groups " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @create_security_group_response_body = <<-RESPONSE
    <CreateSecurityGroupResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </CreateSecurityGroupResponse>
    RESPONSE

    @delete_security_group_response_body = <<-RESPONSE
    <DeleteSecurityGroupResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </DeleteSecurityGroupResponse>
    RESPONSE

    @describe_security_groups_response_body = <<-RESPONSE
    <DescribeSecurityGroupsResponse xm-lns="http://ec2.amazonaws.com/doc/2007-03-01">
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

    @authorize_security_group_ingress_response_body = <<-RESPONSE
    <AuthorizeSecurityGroupIngressResponse xm-lns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </AuthorizeSecurityGroupIngressResponse>
    RESPONSE

    @revoke_security_group_ingress_response_body = <<-RESPONSE
    <RevokeSecurityGroupIngressResponse xm-lns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </RevokeSecurityGroupIngressResponse>
    RESPONSE

  end


  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('CreateSecurityGroup', {"GroupName"=>"WebServers", "GroupDescription"=>"Web"}).
      returns stub(:body => @create_security_group_response_body, :is_a? => true)
    @ec2.create_security_group( :group_name => "WebServers", :group_description => "Web" ).should.be.an.instance_of Hash
  end


  specify "method create_security_group should reject bad arguments" do
    @ec2.stubs(:make_request).with('CreateSecurityGroup', {"GroupName"=>"WebServers", "GroupDescription"=>"Web"}).
      returns stub(:body => @create_security_group_response_body, :is_a? => true)

    lambda { @ec2.create_security_group( :group_name => "WebServers", :group_description => "Web" ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.create_security_group() }.should.raise(AWS::ArgumentError)

    # :group_name can't be nil or empty
    lambda { @ec2.create_security_group( :group_name => "", :group_description => "Web" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_security_group( :group_name => nil, :group_description => "Web" ) }.should.raise(AWS::ArgumentError)

    # :group_description can't be nil or empty
    lambda { @ec2.create_security_group( :group_name => "WebServers", :group_description => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_security_group( :group_name => "WebServers", :group_description => nil ) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be deleted" do
    @ec2.stubs(:make_request).with('DeleteSecurityGroup', {"GroupName"=>"WebServers"}).
      returns stub(:body => @delete_security_group_response_body, :is_a? => true)
    @ec2.delete_security_group( :group_name => "WebServers" ).should.be.an.instance_of Hash
  end


  specify "method delete_security_group should reject bad arguments" do
    @ec2.stubs(:make_request).with('DeleteSecurityGroup', {"GroupName"=>"WebServers"}).
      returns stub(:body => @delete_security_group_response_body, :is_a? => true)

    lambda { @ec2.delete_security_group( :group_name => "WebServers" ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.delete_security_group() }.should.raise(AWS::ArgumentError)

    # :group_name can't be nil or empty
    lambda { @ec2.delete_security_group( :group_name => "" ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.delete_security_group( :group_name => nil ) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be described with describe_security_groups" do
    @ec2.stubs(:make_request).with('DescribeSecurityGroups', { "GroupName.1" => "WebServers", "GroupName.2" => "RangedPortsBySource" }).
      returns stub(:body => @describe_security_groups_response_body, :is_a? => true)
    @ec2.describe_security_groups( :group_name => ["WebServers", "RangedPortsBySource"] ).should.be.an.instance_of Hash

    response = @ec2.describe_security_groups( :group_name => ["WebServers", "RangedPortsBySource"] )

    response.securityGroupInfo.item[0].ownerId.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response.securityGroupInfo.item[0].groupName.should.equal "WebServers"
    response.securityGroupInfo.item[0].groupDescription.should.equal "Web"
    response.securityGroupInfo.item[0].ipPermissions.item[0].ipProtocol.should.equal "tcp"
    response.securityGroupInfo.item[0].ipPermissions.item[0].fromPort.should.equal "80"
    response.securityGroupInfo.item[0].ipPermissions.item[0].toPort.should.equal "80"
    response.securityGroupInfo.item[0].ipPermissions.item[0].groups.should.be.nil
    response.securityGroupInfo.item[0].ipPermissions.item[0].ipRanges.item[0].cidrIp.should.equal "0.0.0.0/0"

    response.securityGroupInfo.item[1].ownerId.should.equal "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
    response.securityGroupInfo.item[1].groupName.should.equal "RangedPortsBySource"
    response.securityGroupInfo.item[1].groupDescription.should.equal "A"
    response.securityGroupInfo.item[1].ipPermissions.item[0].ipProtocol.should.equal "tcp"
    response.securityGroupInfo.item[1].ipPermissions.item[0].fromPort.should.equal "6000"
    response.securityGroupInfo.item[1].ipPermissions.item[0].toPort.should.equal "7000"
    response.securityGroupInfo.item[1].ipPermissions.item[0].groups.should.be.nil
    response.securityGroupInfo.item[1].ipPermissions.item[0].ipRanges.should.be.nil
  end


  specify "method describe_security_groups should reject bad arguments" do
    @ec2.stubs(:make_request).with('DescribeSecurityGroups', {"GroupName.1"=>"WebServers"}).
      returns stub(:body => @describe_security_groups_response_body, :is_a? => true)

      lambda { @ec2.describe_security_groups( :group_name => "WebServers" ) }.should.not.raise(AWS::ArgumentError)

  end


  specify "permissions should be able to be added to a security group with authorize_security_group_ingress." do
    @ec2.stubs(:make_request).with('AuthorizeSecurityGroupIngress', { "GroupName"=>"WebServers",
                                                                      "IpProtocol"=>"tcp",
                                                                      "FromPort"=>"8000",
                                                                      "ToPort"=>"80",
                                                                      "CidrIp"=>"0.0.0.0/24",
                                                                      "SourceSecurityGroupName"=>"Source SG Name",
                                                                      "SourceSecurityGroupOwnerId"=>"123"}).
      returns stub(:body => @authorize_security_group_ingress_response_body, :is_a? => true)

    @ec2.authorize_security_group_ingress( :group_name => "WebServers",
                                           :ip_protocol => "tcp",
                                           :from_port => "8000",
                                           :to_port => "80",
                                           :cidr_ip => "0.0.0.0/24",
                                           :source_security_group_name => "Source SG Name",
                                           :source_security_group_owner_id => "123"
                                           ).should.be.an.instance_of Hash
  end


  specify "permissions should be able to be revoked from a security group with revoke_security_group_ingress." do
    @ec2.stubs(:make_request).with('RevokeSecurityGroupIngress', { "GroupName"=>"WebServers",
                                                                   "IpProtocol"=>"tcp",
                                                                   "FromPort"=>"8000",
                                                                   "ToPort"=>"80",
                                                                   "CidrIp"=>"0.0.0.0/24",
                                                                   "SourceSecurityGroupName"=>"Source SG Name",
                                                                   "SourceSecurityGroupOwnerId"=>"123"}).
      returns stub(:body => @revoke_security_group_ingress_response_body, :is_a? => true)

    @ec2.revoke_security_group_ingress( :group_name => "WebServers",
                                        :ip_protocol => "tcp",
                                        :from_port => "8000",
                                        :to_port => "80",
                                        :cidr_ip => "0.0.0.0/24",
                                        :source_security_group_name => "Source SG Name",
                                        :source_security_group_owner_id => "123"
                                        ).should.be.an.instance_of Hash
  end

end
