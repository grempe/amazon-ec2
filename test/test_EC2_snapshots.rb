#--
# Amazon Web Services EC2 Query API Ruby library, EBS snapshots support
#
# Ruby Gem Name::  amazon-ec2
# Author::    Yann Klis  (mailto:yann.klis@novelys.com)
# Copyright:: Copyright (c) 2008 Yann Klis
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 snaphots " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @describe_snapshots_response_body = <<-RESPONSE
    <DescribeSnapshotsResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <snapshotId>snap-78a54011</snapshotId>
      <volumeId>vol-4d826724</volumeId>
      <status>pending</status>
      <startTime>2008-05-07T12:51:50.000Z</startTime>
      <progress>80%</progress>
    </DescribeSnapshotsResponse>
    RESPONSE

    @create_snapshot_response_body = <<-RESPONSE
    <CreateSnapshotResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <snapshotId>snap-78a54011</snapshotId>
      <volumeId>vol-4d826724</volumeId>
      <status>pending</status>
      <startTime>2008-05-07T12:51:50.000Z</startTime>
      <progress></progress>
      <description>Daily Backup</description>
    </CreateSnapshotResponse>
    RESPONSE

    @delete_snapshot_response_body = <<-RESPONSE
    <DeleteSnapshotResponse xmlns="http://ec2.amazonaws.com/doc/2008-05-05">
      <return>true</return>
    </DeleteSnapshotResponse>
    RESPONSE

  end


  specify "should be able to be described with describe_snapshots" do
    @ec2.stubs(:make_request).with('DescribeSnapshots', {'SnapshotId.1' => 'snap-78a54011'}).
      returns stub(:body => @describe_snapshots_response_body, :is_a? => true)

    @ec2.describe_snapshots( :snapshot_id => "snap-78a54011" ).should.be.an.instance_of Hash

    response = @ec2.describe_snapshots( :snapshot_id => "snap-78a54011" )
    response.snapshotId.should.equal "snap-78a54011"
    response.volumeId.should.equal "vol-4d826724"
    response.status.should.equal "pending"
    response.progress.should.equal "80%"
  end

  specify "should be able to be created with a volume_id" do
    @ec2.stubs(:make_request).with('CreateSnapshot', {"VolumeId" => "vol-4d826724"}).
      returns stub(:body => @create_snapshot_response_body, :is_a? => true)

    @ec2.create_snapshot( :volume_id => "vol-4d826724" ).should.be.an.instance_of Hash

    response = @ec2.create_snapshot( :volume_id => "vol-4d826724" )
    response.snapshotId.should.equal "snap-78a54011"
    response.volumeId.should.equal "vol-4d826724"
    response.status.should.equal "pending"
    response.progress.should.equal nil
  end

  specify "should be able to be created with a volume_id and description" do
    @ec2.stubs(:make_request).with('CreateSnapshot', {"VolumeId" => "vol-4d826724", "Description" => "Daily Backup"}).
      returns stub(:body => @create_snapshot_response_body, :is_a? => true)

    @ec2.create_snapshot( :volume_id => "vol-4d826724", :description => "Daily Backup" ).should.be.an.instance_of Hash

    response = @ec2.create_snapshot( :volume_id => "vol-4d826724", :description => "Daily Backup")
    response.snapshotId.should.equal "snap-78a54011"
    response.volumeId.should.equal "vol-4d826724"
    response.status.should.equal "pending"
    response.progress.should.equal nil
    response.description.should.equal "Daily Backup"
  end

  specify "should be able to be deleted with a snapsot_id" do
    @ec2.stubs(:make_request).with('DeleteSnapshot', {"SnapshotId" => "snap-78a54011"}).
      returns stub(:body => @delete_snapshot_response_body, :is_a? => true)

    @ec2.delete_snapshot( :snapshot_id => "snap-78a54011" ).should.be.an.instance_of Hash

    response = @ec2.delete_snapshot( :snapshot_id => "snap-78a54011" )
    response.return.should.equal "true"
  end

end
