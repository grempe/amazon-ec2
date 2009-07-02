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

context "EC2 keypairs " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @create_keypair_response_body = <<-RESPONSE
      <CreateKeyPairResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <keyName>example-key-name</keyName>
      <keyFingerprint>1f:51:ae:28:bf:89:e9:d8:1f:25:5d:37:2d:7d:b8:ca:9f:f5:f1:6f</keyFingerprint>
      <keyMaterial>-----BEGIN RSA PRIVATE KEY-----
      MIIEoQIBAAKCAQBuLFg5ujHrtm1jnutSuoO8Xe56LlT+HM8v/xkaa39EstM3/aFxTHgElQiJLChp
      HungXQ29VTc8rc1bW0lkdi23OH5eqkMHGhvEwqa0HWASUMll4o3o/IX+0f2UcPoKCOVUR+jx71Sg
      5AU52EQfanIn3ZQ8lFW7Edp5a3q4DhjGlUKToHVbicL5E+g45zfB95wIyywWZfeW/UUF3LpGZyq/
      ebIUlq1qTbHkLbCC2r7RTn8vpQWp47BGVYGtGSBMpTRP5hnbzzuqj3itkiLHjU39S2sJCJ0TrJx5
      i8BygR4s3mHKBj8l+ePQxG1kGbF6R4yg6sECmXn17MRQVXODNHZbAgMBAAECggEAY1tsiUsIwDl5
      91CXirkYGuVfLyLflXenxfI50mDFms/mumTqloHO7tr0oriHDR5K7wMcY/YY5YkcXNo7mvUVD1pM
      ZNUJs7rw9gZRTrf7LylaJ58kOcyajw8TsC4e4LPbFaHwS1d6K8rXh64o6WgW4SrsB6ICmr1kGQI7
      3wcfgt5ecIu4TZf0OE9IHjn+2eRlsrjBdeORi7KiUNC/pAG23I6MdDOFEQRcCSigCj+4/mciFUSA
      SWS4dMbrpb9FNSIcf9dcLxVM7/6KxgJNfZc9XWzUw77Jg8x92Zd0fVhHOux5IZC+UvSKWB4dyfcI
      tE8C3p9bbU9VGyY5vLCAiIb4qQKBgQDLiO24GXrIkswF32YtBBMuVgLGCwU9h9HlO9mKAc2m8Cm1
      jUE5IpzRjTedc9I2qiIMUTwtgnw42auSCzbUeYMURPtDqyQ7p6AjMujp9EPemcSVOK9vXYL0Ptco
      xW9MC0dtV6iPkCN7gOqiZXPRKaFbWADp16p8UAIvS/a5XXk5jwKBgQCKkpHi2EISh1uRkhxljyWC
      iDCiK6JBRsMvpLbc0v5dKwP5alo1fmdR5PJaV2qvZSj5CYNpMAy1/EDNTY5OSIJU+0KFmQbyhsbm
      rdLNLDL4+TcnT7c62/aH01ohYaf/VCbRhtLlBfqGoQc7+sAc8vmKkesnF7CqCEKDyF/dhrxYdQKB
      gC0iZzzNAapayz1+JcVTwwEid6j9JqNXbBc+Z2YwMi+T0Fv/P/hwkX/ypeOXnIUcw0Ih/YtGBVAC
      DQbsz7LcY1HqXiHKYNWNvXgwwO+oiChjxvEkSdsTTIfnK4VSCvU9BxDbQHjdiNDJbL6oar92UN7V
      rBYvChJZF7LvUH4YmVpHAoGAbZ2X7XvoeEO+uZ58/BGKOIGHByHBDiXtzMhdJr15HTYjxK7OgTZm
      gK+8zp4L9IbvLGDMJO8vft32XPEWuvI8twCzFH+CsWLQADZMZKSsBasOZ/h1FwhdMgCMcY+Qlzd4
      JZKjTSu3i7vhvx6RzdSedXEMNTZWN4qlIx3kR5aHcukCgYA9T+Zrvm1F0seQPbLknn7EqhXIjBaT
      P8TTvW/6bdPi23ExzxZn7KOdrfclYRph1LHMpAONv/x2xALIf91UB+v5ohy1oDoasL0gij1houRe
      2ERKKdwz0ZL9SWq6VTdhr/5G994CK72fy5WhyERbDjUIdHaK3M849JJuf8cSrvSb4g==
      -----END RSA PRIVATE KEY-----</keyMaterial>
      </CreateKeyPairResponse>
    RESPONSE

    @describe_keypairs_response_body = <<-RESPONSE
    <DescribeKeyPairsResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <keySet>
        <item>
          <keyName>example-key-name</keyName>
          <keyFingerprint>1f:51:ae:28:bf:89:e9:d8:1f:25:5d:37:2d:7d:b8:ca:9f:f5:f1:6f</keyFingerprint>
        </item>
      </keySet>
    </DescribeKeyPairsResponse>
    RESPONSE

    @delete_keypair_body = <<-RESPONSE
    <DeleteKeyPair xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </DeleteKeyPair>
    RESPONSE

  end


  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('CreateKeyPair', {"KeyName"=>"example-key-name"}).
      returns stub(:body => @create_keypair_response_body, :is_a? => true)

    @ec2.create_keypair( :key_name => "example-key-name" ).should.be.an.instance_of Hash

    response = @ec2.create_keypair( :key_name => "example-key-name" )
    response.keyName.should.equal "example-key-name"
    response.keyFingerprint.should.equal "1f:51:ae:28:bf:89:e9:d8:1f:25:5d:37:2d:7d:b8:ca:9f:f5:f1:6f"
    response.keyMaterial.should.not.equal ""
    response.keyMaterial.should.not.be.nil
  end


  specify "method create_keypair should reject bad arguments" do
    @ec2.stubs(:make_request).with('CreateKeyPair', {"KeyName"=>"example-key-name"}).
      returns stub(:body => @create_keypair_response_body, :is_a? => true)

    lambda { @ec2.create_keypair( :key_name => "example-key-name" ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.create_keypair() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_keypair( :key_name => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_keypair( :key_name => "" ) }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be described with describe_keypairs" do
    @ec2.stubs(:make_request).with('DescribeKeyPairs', {"KeyName.1"=>"example-key-name"}).
      returns stub(:body => @describe_keypairs_response_body, :is_a? => true)
    @ec2.describe_keypairs( :key_name => "example-key-name" ).should.be.an.instance_of Hash
    response = @ec2.describe_keypairs( :key_name => "example-key-name" )
    response.keySet.item[0].keyName.should.equal "example-key-name"
    response.keySet.item[0].keyFingerprint.should.equal "1f:51:ae:28:bf:89:e9:d8:1f:25:5d:37:2d:7d:b8:ca:9f:f5:f1:6f"
  end


  specify "should be able to be deleted with delete_keypairs" do
    @ec2.stubs(:make_request).with('DeleteKeyPair', {"KeyName"=>"example-key-name"}).
      returns stub(:body => @delete_keypair_body, :is_a? => true)
    @ec2.delete_keypair( :key_name => "example-key-name" ).should.be.an.instance_of Hash
    response = @ec2.delete_keypair( :key_name => "example-key-name" )
    response.return.should.equal "true"
  end


  specify "method delete_keypair should reject bad argument" do
    @ec2.stubs(:make_request).with('DeleteKeyPair', {"KeyName"=>"example-key-name"}).
      returns stub(:body => @delete_keypair_body, :is_a? => true)

    lambda { @ec2.delete_keypair( :key_name => "example-key-name" ) }.should.not.raise(AWS::ArgumentError)
    lambda { @ec2.delete_keypair() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.delete_keypair( :key_name => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.delete_keypair( :key_name => "" ) }.should.raise(AWS::ArgumentError)
  end


end
