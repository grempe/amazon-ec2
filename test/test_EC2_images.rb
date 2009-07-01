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

context "An EC2 image " do

  before do
    @ec2 = EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @register_image_response_body = <<-RESPONSE
    <RegisterImageResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <imageId>ami-61a54008</imageId>
    </RegisterImageResponse>
    RESPONSE

    @describe_image_response_body = <<-RESPONSE
    <DescribeImagesResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <imagesSet>
        <item>
          <imageId>ami-61a54008</imageId>
          <imageLocation>foobar1/image.manifest.xml</imageLocation>
          <imageState>available</imageState>
          <imageOwnerId>AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA</imageOwnerId>
          <isPublic>true</isPublic>
          <productCodes>
            <item>
              <productCode>774F4FF8</productCode>
            </item>
          </productCodes>
        </item>
        <item>
          <imageId>ami-61a54009</imageId>
          <imageLocation>foobar2/image.manifest.xml</imageLocation>
          <imageState>deregistered</imageState>
          <imageOwnerId>ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ</imageOwnerId>
          <isPublic>false</isPublic>
        </item>
      </imagesSet>
    </DescribeImagesResponse>
    RESPONSE

    @deregister_image_response_body = <<-RESPONSE
    <DeregisterImageResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </DeregisterImageResponse>
    RESPONSE

  end


  specify "should be able to be registered" do
    @ec2.stubs(:make_request).with('RegisterImage', {"ImageLocation"=>"mybucket-myimage.manifest.xml"}).
      returns stub(:body => @register_image_response_body, :is_a? => true)
    @ec2.register_image(:image_location => "mybucket-myimage.manifest.xml").imageId.should.equal "ami-61a54008"
    @ec2.register_image(:image_location => "mybucket-myimage.manifest.xml").should.be.an.instance_of Hash
  end


  specify "method register_image should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.register_image() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.register_image(:image_location => "") }.should.raise(EC2::ArgumentError)
  end


  specify "should be able to be described and return the correct Ruby response class for parent and members" do
    @ec2.stubs(:make_request).with('DescribeImages', {}).
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images.should.be.an.instance_of Hash
    response = @ec2.describe_images
    response.should.be.an.instance_of Hash
  end


  specify "should be able to be described with no params and return an imagesSet" do
    @ec2.stubs(:make_request).with('DescribeImages', {}).
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images.imagesSet.item.length.should.equal 2
  end

  specify "should be able to be described by an Array of ImageId.N ID's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', {"ImageId.1"=>"ami-61a54008", "ImageId.2"=>"ami-61a54009"}).
      returns stub(:body => @describe_image_response_body, :is_a? => true)
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
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] ).imagesSet.item.length.should.equal 2

    # owner ID's
    response = @ec2.describe_images( :owner_id => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be described by an owner of 'self' and return an array of Items that I own" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "self").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => "self" ).imagesSet.item.length.should.equal 2

    # 'self' - Those that I own
    response = @ec2.describe_images( :owner_id => "self" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
  end


  specify "should be able to be described by an owner of 'amazon' and return an array of Items that are Amazon Public AMI's" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "amazon").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => "amazon" ).imagesSet.item.length.should.equal 2

    # 'amazon' - Those that are owned and created by AWS
    response = @ec2.describe_images( :owner_id => "amazon" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
  end


  specify "should be able to be described by an owners with Owner.N ID's who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ExecutableBy.2" => "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] ).imagesSet.item.length.should.equal 2

    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be described by an owners with Owner.N of 'self' who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "self").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => "self" ).imagesSet.item.length.should.equal 2

    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => "self" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be described by an owners with Owner.N of 'all' who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "all").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => "all" ).imagesSet.item.length.should.equal 2

    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => "all" )
    response.imagesSet.item[0].imageId.should.equal "ami-61a54008"
    response.imagesSet.item[1].imageId.should.equal "ami-61a54009"
  end


  specify "should be able to be de-registered" do
    @ec2.stubs(:make_request).with('DeregisterImage', {"ImageId"=>"ami-61a54008"}).
      returns stub(:body => @deregister_image_response_body, :is_a? => true)
    @ec2.deregister_image(:image_id => "ami-61a54008" ).should.be.an.instance_of Hash
    @ec2.deregister_image(:image_id => "ami-61a54008" ).return.should.equal "true"
  end


  specify "method deregister_image should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.deregister_image() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.deregister_image( :image_id => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.deregister_image( :image_id => "" ) }.should.raise(EC2::ArgumentError)
  end


end
