#--
# Amazon Web Services EC2 Query API Ruby library, EBS volumes support
#
# Ruby Gem Name::  amazon-ec2
# Author::    Yann Klis  (mailto:yann.klis@novelys.com)
# Copyright:: Copyright (c) 2008 Yann Klis
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 volumes " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @describe_volumes_response_body = <<-RESPONSE
    <DescribeVolumesResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <volumeSet>
        <item>
          <volumeId>vol-4282672b</volumeId>
          <size>800</size>
          <status>in-use</status>
          <createTime>2008-05-07T11:51:50.000Z</createTime>
          <attachmentSet>
            <item>
              <volumeId>vol-4282672b</volumeId>
              <instanceId>i-6058a509</instanceId>
              <size>800</size>
              <status>attached</status>
              <attachTime>2008-05-07T12:51:50.000Z</attachTime>
            </item>
          </attachmentSet>
        </item>
      </volumeSet>
    </DescribeVolumesResponse>
    RESPONSE

    @create_volume_response_body = <<-RESPONSE
    <CreateVolumeResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <volumeId>vol-4d826724</volumeId>
      <size>800</size>
      <status>creating</status>
      <createTime>2008-05-07T11:51:50.000Z</createTime>
      <zone>us-east-1a</zone>
      <snapshotId></snapshotId>
    </CreateVolumeResponse>
    RESPONSE

    @delete_volume_response_body = <<-RESPONSE
    <ReleaseAddressResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <return>true</return>
    </ReleaseAddressResponse>
    RESPONSE

    @attach_volume_response_body = <<-RESPONSE
    <AttachVolumeResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <volumeId>vol-4d826724</volumeId>
      <instanceId>i-6058a509</instanceId>
      <device>/dev/sdh</device>
      <status>attaching</status>
      <attachTime>2008-05-07T11:51:50.000Z</attachTime>
    </AttachVolumeResponse>
    RESPONSE

    @detach_volume_response_body = <<-RESPONSE
    <DetachVolumeResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <volumeId>vol-4d826724</volumeId>
      <instanceId>i-6058a509</instanceId>
      <device>/dev/sdh</device>
      <status>detaching</status>
      <attachTime>2008-05-08T11:51:50.000Z</attachTime>
    </DetachVolumeResponse>
    RESPONSE

  end


  specify "should be able to be described with describe_volumes" do
    @ec2.stubs(:make_request).with('DescribeVolumes', {"VolumeId.1"=>"vol-4282672b"}).
      returns stub(:body => @describe_volumes_response_body, :is_a? => true)

    @ec2.describe_volumes( :volume_id => ["vol-4282672b"] ).should.be.an.instance_of Hash

    response = @ec2.describe_volumes( :volume_id => ["vol-4282672b"] )
    response.volumeSet.item[0].volumeId.should.equal "vol-4282672b"
    response.volumeSet.item[0].attachmentSet.item[0]['size'].should.equal "800"
    response.volumeSet.item[0].attachmentSet.item[0].volumeId.should.equal "vol-4282672b"
    response.volumeSet.item[0].attachmentSet.item[0].instanceId.should.equal "i-6058a509"
  end

  specify "should be able to be created with an availability_zone with size" do
    @ec2.stubs(:make_request).with('CreateVolume', {"AvailabilityZone" => "us-east-1a", "Size"=>"800", "SnapshotId"=>""}).
      returns stub(:body => @create_volume_response_body, :is_a? => true)

    @ec2.create_volume( :availability_zone => "us-east-1a", :size => "800" ).should.be.an.instance_of Hash

    response = @ec2.create_volume( :availability_zone => "us-east-1a", :size => "800" )
    response.volumeId.should.equal "vol-4d826724"
    response['size'].should.equal "800"
    response.status.should.equal "creating"
    response.zone.should.equal "us-east-1a"
  end

  specify "should be able to be deleted with a volume_id" do
    @ec2.stubs(:make_request).with('DeleteVolume', {"VolumeId" => "vol-4282672b"}).
      returns stub(:body => @delete_volume_response_body, :is_a? => true)

    @ec2.delete_volume( :volume_id => "vol-4282672b" ).should.be.an.instance_of Hash

    response = @ec2.delete_volume( :volume_id => "vol-4282672b" )
    response.return.should.equal "true"
  end

  specify "should be able to be attached with a volume_id with an instance_id with a device" do
    @ec2.stubs(:make_request).with('AttachVolume', {"VolumeId" => "vol-4d826724", "InstanceId"=>"i-6058a509", "Device"=>"/dev/sdh"}).
      returns stub(:body => @attach_volume_response_body, :is_a? => true)

    @ec2.attach_volume( :volume_id => "vol-4d826724", :instance_id => "i-6058a509", :device => "/dev/sdh" ).should.be.an.instance_of Hash

    response = @ec2.attach_volume( :volume_id => "vol-4d826724", :instance_id => "i-6058a509", :device => "/dev/sdh" )
    response.volumeId.should.equal "vol-4d826724"
    response.instanceId.should.equal "i-6058a509"
    response.device.should.equal "/dev/sdh"
    response.status.should.equal "attaching"
  end

  specify "should be able to be detached with a volume_id with an instance_id" do
    @ec2.stubs(:make_request).with('DetachVolume', {"VolumeId" => "vol-4d826724", "InstanceId"=>"i-6058a509", "Device"=>"", "Force"=>""}).
      returns stub(:body => @detach_volume_response_body, :is_a? => true)

    @ec2.detach_volume( :volume_id => "vol-4d826724", :instance_id => "i-6058a509" ).should.be.an.instance_of Hash

    response = @ec2.detach_volume( :volume_id => "vol-4d826724", :instance_id => "i-6058a509" )
    response.volumeId.should.equal "vol-4d826724"
    response.instanceId.should.equal "i-6058a509"
    response.device.should.equal "/dev/sdh"
    response.status.should.equal "detaching"
  end

  specify "should be able to be force detached with a string" do
    @ec2.stubs(:make_request).with('DetachVolume', {"VolumeId" => "vol-4d826724", "InstanceId"=>"i-6058a509", "Device"=>"", "Force"=>"true"}).
      returns stub(:body => @detach_volume_response_body, :is_a? => true)

    response = @ec2.detach_volume( :volume_id => "vol-4d826724", :instance_id => "i-6058a509", :force => 'true' )
    response.volumeId.should.equal "vol-4d826724"
  end

  specify "should be able to be force detached with a Boolean" do
    @ec2.stubs(:make_request).with('DetachVolume', {"VolumeId" => "vol-4d826724", "InstanceId"=>"i-6058a509", "Device"=>"", "Force"=>"true"}).
      returns stub(:body => @detach_volume_response_body, :is_a? => true)

    response = @ec2.detach_volume( :volume_id => "vol-4d826724", :instance_id => "i-6058a509", :force => true )
    response.volumeId.should.equal "vol-4d826724"
  end

end
