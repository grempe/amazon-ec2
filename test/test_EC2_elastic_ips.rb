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

context "EC2 elastic IP addresses " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @allocate_address_body = <<-RESPONSE
    <AllocateAddressResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01">
      <publicIp>67.202.55.255</publicIp>
    </AllocateAddressResponse>
    RESPONSE

    @describe_addresses_response_body = <<-RESPONSE
    <DescribeAddressesResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01">
       <addressesSet>
         <item>
           <instanceId>i-28a64341</instanceId>
           <publicIp>67.202.55.255</publicIp>
         </item>
       </addressesSet>
    </DescribeAddressesResponse>
    RESPONSE

    @release_address_response_body = <<-RESPONSE
    <ReleaseAddressResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01">
      <return>true</return>
    </ReleaseAddressResponse>
    RESPONSE

    @associate_address_response_body = <<-RESPONSE
    <AssociateAddressResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01">
      <return>true</return>
    </AssociateAddressResponse>
    RESPONSE

    @disassociate_address_response_body = <<-RESPONSE
    <DisassociateAddressResponse xmlns="http://ec2.amazonaws.com/doc/2008-02-01">
      <return>true</return>
    </DisassociateAddressResponse>
    RESPONSE

  end


  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('AllocateAddress', {}).
      returns stub(:body => @allocate_address_body, :is_a? => true)

    @ec2.allocate_address.should.be.an.instance_of Hash

    response = @ec2.allocate_address
    response.publicIp.should.equal "67.202.55.255"
  end


  #specify "method create_keypair should reject bad arguments" do
  #  @ec2.stubs(:make_request).with('CreateKeyPair', {"KeyName"=>"example-key-name"}).
  #    returns stub(:body => @create_keypair_response_body, :is_a? => true)
  #
  #  lambda { @ec2.create_keypair( :key_name => "example-key-name" ) }.should.not.raise(AWS::ArgumentError)
  #  lambda { @ec2.create_keypair() }.should.raise(AWS::ArgumentError)
  #  lambda { @ec2.create_keypair( :key_name => nil ) }.should.raise(AWS::ArgumentError)
  #  lambda { @ec2.create_keypair( :key_name => "" ) }.should.raise(AWS::ArgumentError)
  #end


  specify "should be able to be described with describe_addresses" do
    @ec2.stubs(:make_request).with('DescribeAddresses', {"PublicIp.1"=>"67.202.55.255"}).
      returns stub(:body => @describe_addresses_response_body, :is_a? => true)

    @ec2.describe_addresses( :public_ip => "67.202.55.255" ).should.be.an.instance_of Hash

    response = @ec2.describe_addresses( :public_ip => "67.202.55.255" )
    response.addressesSet.item[0].instanceId.should.equal "i-28a64341"
    response.addressesSet.item[0].publicIp.should.equal "67.202.55.255"
  end


  specify "should be able to be released with release_address" do
    @ec2.stubs(:make_request).with('ReleaseAddress', {"PublicIp" => "67.202.55.255"}).
      returns stub(:body => @release_address_response_body, :is_a? => true)

    @ec2.release_address( :public_ip => "67.202.55.255" ).should.be.an.instance_of Hash

    response = @ec2.release_address( :public_ip => "67.202.55.255" )
    response.return.should.equal "true"
  end


  specify "should be able to be associated with an instance with associate_address" do
    @ec2.stubs(:make_request).with('AssociateAddress', {"InstanceId" => "i-2ea64347", "PublicIp"=>"67.202.55.255"}).
      returns stub(:body => @associate_address_response_body, :is_a? => true)

    @ec2.associate_address( :instance_id => "i-2ea64347", :public_ip => "67.202.55.255" ).should.be.an.instance_of Hash

    response = @ec2.associate_address( :instance_id => "i-2ea64347", :public_ip => "67.202.55.255" )
    response.return.should.equal "true"
  end


  specify "method associate_address should reject bad arguments" do
    @ec2.stubs(:make_request).with('AssociateAddress', {"InstanceId" => "i-2ea64347", "PublicIp"=>"67.202.55.255"}).
      returns stub(:body => @associate_address_response_body, :is_a? => true)

    lambda { @ec2.associate_address( :instance_id => "i-2ea64347", :public_ip => "67.202.55.255" ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.associate_address() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.associate_address( :instance_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.associate_address( :public_ip => "" ) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be disassociated with an instance with disassociate_address" do
    @ec2.stubs(:make_request).with('DisassociateAddress', {'PublicIp' => '67.202.55.255'}).
      returns stub(:body => @disassociate_address_response_body, :is_a? => true)

    @ec2.disassociate_address( :public_ip => "67.202.55.255" ).should.be.an.instance_of Hash

    response = @ec2.disassociate_address( :public_ip => "67.202.55.255" )
    response.return.should.equal "true"
  end


  specify "method disassociate_address should reject bad arguments" do
    @ec2.stubs(:make_request).with('DisassociateAddress', {'PublicIp' => '67.202.55.255'}).
      returns stub(:body => @disassociate_address_response_body, :is_a? => true)

    lambda { @ec2.disassociate_address( :public_ip => "67.202.55.255" ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.disassociate_address() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.disassociate_address( :public_ip => "" ) }.should.raise(AWS::ArgumentError)
  end


end
