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

context "An EC2 spot instances request " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @create_spot_instances_request_response_body = <<-RESPONSE
    <RequestSpotInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <spotInstanceRequestSet>
        <item>
          <spotInstanceRequestId>sir-f102a405</spotInstanceRequestId>
          <spotPrice>0.50</spotPrice>
          <type>one-time</type>
          <state>open</state>
          <fault/>
          <validFrom/>
          <validUntil/>
          <launchGroup/>
          <availabilityZoneGroup>MyAzGroup</availabilityZoneGroup>
          <launchSpecification>
            <imageId> i-43a4412a</imageId>
            <keyName>MyKeypair</keyName>
            <groupSet>websrv</groupSet>
            <instanceType>m1.small</instanceType>
          </launchSpecification>
          <instanceId>i-123345678</instanceId>
          <createTime>2009-10-19T00:00:00+0000</createTime>
          <productDescription/>
        </item>
      </spotInstanceRequestSet>
    </RequestSpotInstancesResponse>
    RESPONSE

    @describe_spot_instance_requests_response_body = <<-RESPONSE
    <DescribeSpotInstanceRequestsResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <spotInstanceRequestSet>
        <item>
          <spotInstanceRequestId>sir-e95fae02</spotInstanceRequestId>
          <spotPrice>0.01</spotPrice>
          <type>one-time</type>
          <state>open</state>
          <createTime>2009-12-04T22:51:14.000Z</createTime>
          <productDescription>Linux/UNIX</productDescription>
          <launchSpecification>
            <imageId>ami-235fba4a</imageId>
            <groupSet>
              <item>
                <groupId>default</groupId>
              </item>
            </groupSet>
            <instanceType>m1.small</instanceType>
            <blockDeviceMapping/>
            <monitoring>
              <enabled>false</enabled>
            </monitoring>
          </launchSpecification>
          <instanceId>i-2fd4ca67</instanceId>
        </item>
      </spotInstanceRequestSet>
    </DescribeSpotInstanceRequestsResponse>
    RESPONSE

    @cancel_spot_instance_requests_response_body = <<-RESPONSE
    <CancelSpotInstanceRequestsResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <requestId>59dbff89-35bd-4eac-99ed-be587ed81825</requestId>
      <spotInstanceRequestSet>
        <item>
          <spotInstanceRequestId>sir-e95fae02</spotInstanceRequestId>
          <state>cancelled</state>
        </item>
      </spotInstanceRequestSet>
    </CancelSpotInstanceRequestsResponse>
    RESPONSE

  end


  specify "should be able to be created" do
    @ec2.stubs(:make_request).with('RequestSpotInstances', {"SpotPrice"=>"0.50", "InstanceCount"=>"1"}).
      returns stub(:body => @create_spot_instances_request_response_body, :is_a? => true)
    @ec2.create_spot_instances_request(:spot_price => "0.50").should.be.an.instance_of Hash
    @ec2.create_spot_instances_request(:spot_price => "0.50").spotInstanceRequestSet.item.first.spotInstanceRequestId.should.equal "sir-f102a405"
  end


  specify "method create_image should raise an exception when called with nil/empty string arguments" do
    lambda { @ec2.create_image() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "", :name => "fooname") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "fooid", :name => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => nil, :name => "fooname") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "fooid", :name => nil) }.should.raise(AWS::ArgumentError)
  end


  specify "method create_image should raise an exception when called with bad arguments" do
    lambda { @ec2.create_image(:instance_id => "fooid", :name => "f"*2) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "fooid", :name => "f"*129) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "fooid", :name => "f"*128, :description => "f"*256) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "fooid", :name => "f"*128, :no_reboot => "true") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.create_image(:instance_id => "fooid", :name => "f"*128, :no_reboot => "false") }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be registered" do
    @ec2.stubs(:make_request).with('RegisterImage', {"ImageLocation"=>"mybucket-myimage.manifest.xml"}).
      returns stub(:body => @register_image_response_body, :is_a? => true)
    @ec2.register_image(:image_location => "mybucket-myimage.manifest.xml").imageId.should.equal "ami-61a54008"
    @ec2.register_image(:image_location => "mybucket-myimage.manifest.xml").should.be.an.instance_of Hash
  end


  specify "method register_image should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.register_image() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.register_image(:image_location => "") }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to be described and return the correct Ruby response class for parent and members" do
    @ec2.stubs(:make_request).with('DescribeImages', {}).
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images.should.be.an.instance_of Hash
    response = @ec2.describe_images
    response.should.be.an.instance_of Hash
  end


  specify "should be able to be described with no params and return an imagesSet" do
    @ec2.stubs(:make_request).with('DescribeImages', {}).
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images.imagesSet.item.length.should.equal 2
  end

  specify "should be able to be described by an Array of ImageId.N ID's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', {"ImageId.1"=>"ami-61a54008", "ImageId.2"=>"ami-61a54009"}).
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :image_id => ["ami-61a54008", "ami-61a54009"] ).imagesSet.item.length.should.equal 2

    response = @ec2.describe_images( :image_id => ["ami-61a54008", "ami-61a54009"] )

    # test first 'Item' object returned
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[0].imageLocation.should.equal "foobar1/image.manifest.xml"
    response.imagesSet.item[0].imageState.should.equal "available"
    response.imagesSet.item[0].imageOwnerId.should.equal "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA"
    response.imagesSet.item[0].isPublic.should.equal "true"
    response.imagesSet.item[0].productCodes.item[0].productCode.should.equal "774F4FF8"

    # test second 'Item' object returned
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
    response.imagesSet.item[1].imageLocation.should.equal "foobar2/image.manifest.xml"
    response.imagesSet.item[1].imageState.should.equal "deregistered"
    response.imagesSet.item[1].imageOwnerId.should.equal "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"
    response.imagesSet.item[1].isPublic.should.equal "false"
  end


  specify "should be able to be described by an owners with Owner.N ID's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "Owner.2" => "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ").
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] ).imagesSet.item.length.should.equal 2

    # owner ID's
    response = @ec2.describe_images( :owner_id => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be described by an owner of 'self' and return an array of Items that I own" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "self").
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => "self" ).imagesSet.item.length.should.equal 2

    # 'self' - Those that I own
    response = @ec2.describe_images( :owner_id => "self" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
  end


  specify "should be able to be described by an owner of 'amazon' and return an array of Items that are Amazon Public AMI's" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "amazon").
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => "amazon" ).imagesSet.item.length.should.equal 2

    # 'amazon' - Those that are owned and created by AWS
    response = @ec2.describe_images( :owner_id => "amazon" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
  end


  specify "should be able to be described by an owners with Owner.N ID's who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ExecutableBy.2" => "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ").
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] ).imagesSet.item.length.should.equal 2

    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be described by an owners with Owner.N of 'self' who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "self").
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => "self" ).imagesSet.item.length.should.equal 2

    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => "self" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be described by an owners with Owner.N of 'all' who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "all").
      returns stub(:body => @describe_spot_instance_requests_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => "all" ).imagesSet.item.length.should.equal 2

    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => "all" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be de-registered" do
    @ec2.stubs(:make_request).with('DeregisterImage', {"ImageId"=>"ami-61a54008"}).
      returns stub(:body => @cancel_spot_instance_requests_response_body, :is_a? => true)
    @ec2.deregister_image(:image_id => "ami-61a54008" ).should.be.an.instance_of Hash
    @ec2.deregister_image(:image_id => "ami-61a54008" ).return.should.equal "true"
  end


  specify "method deregister_image should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.deregister_image() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.deregister_image( :image_id => nil ) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.deregister_image( :image_id => "" ) }.should.raise(AWS::ArgumentError)
  end


end
