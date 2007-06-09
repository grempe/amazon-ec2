require File.dirname(__FILE__) + '/test_helper.rb'

context "An EC2 image " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new( :aws_access_key_id => "not a key", :aws_secret_access_key => "not a secret" )
    
    @register_image_response_body = <<-RESPONSE
    <RegisterImageResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
      <imageId>ami-61a54008</imageId>
    </RegisterImageResponse>
    RESPONSE
    
    @describe_image_response_body = <<-RESPONSE
    <DescribeImagesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
      <imagesSet>
        <item>
          <imageId>ami-61a54008</imageId>
          <imageLocation>foobar1/image.manifest.xml</imageLocation>
          <imageState>available</imageState>
          <imageOwnerId>AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA</imageOwnerId>
          <isPublic>true</isPublic>
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
    <DeregisterImageResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
      <return>true</return> 
    </DeregisterImageResponse>
    RESPONSE
    
  end
  
  
  specify "should be able to be registered" do
    @ec2.stubs(:make_request).with('RegisterImage', {"ImageLocation"=>"mybucket-myimage.manifest.xml"}).
      returns stub(:body => @register_image_response_body, :is_a? => true)
    @ec2.register_image(:image_location => "mybucket-myimage.manifest.xml").image_id.should.equal "ami-61a54008"
    @ec2.register_image(:image_location => "mybucket-myimage.manifest.xml").should.be.an.instance_of EC2::RegisterImageResponse
  end
  
  
  specify "method register_image should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.register_image() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.register_image(:image_location => "") }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "should be able to be described and return the correct Ruby response class for parent and members" do
    @ec2.stubs(:make_request).with('DescribeImages', {}).
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images.should.be.an.instance_of EC2::DescribeImagesResponseSet
    response = @ec2.describe_images
    response[0].should.be.an.instance_of EC2::Item
  end
  
  
  specify "should be able to be described with no params and return an array of more than one items" do
    @ec2.stubs(:make_request).with('DescribeImages', {}).
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images.length.should.equal 2
    response = @ec2.describe_images
    response[0].image_id.should.equal "ami-61a54008"
    response[1].image_id.should.equal "ami-61a54009"
  end
  
  specify "should be able to be described by an Array of ImageId.N ID's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', {"ImageId.1"=>"ami-61a54008", "ImageId.2"=>"ami-61a54009"}).
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :image_id => ["ami-61a54008", "ami-61a54009"] ).length.should.equal 2
    
    response = @ec2.describe_images( :image_id => ["ami-61a54008", "ami-61a54009"] )
    
    # test first 'Item' object returned
    response[0].image_id.should.equal "ami-61a54008"
    response[0].image_location.should.equal "foobar1/image.manifest.xml"
    response[0].image_state.should.equal "available"
    response[0].image_owner_id.should.equal "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA"
    response[0].is_public.should.equal true
    
    # test second 'Item' object returned
    response[1].image_id.should.equal "ami-61a54009"
    response[1].image_location.should.equal "foobar2/image.manifest.xml"
    response[1].image_state.should.equal "deregistered"
    response[1].image_owner_id.should.equal "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"
    response[1].is_public.should.equal false
  end
  
  
  specify "should be able to be described by an owners with Owner.N ID's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "Owner.2" => "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] ).length.should.equal 2
    
    # owner ID's
    response = @ec2.describe_images( :owner_id => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] )
    response[0].image_id.should.equal "ami-61a54008"
    response[1].image_id.should.equal "ami-61a54009"
  end
  
  
  specify "should be able to be described by an owner of 'self' and return an array of Items that I own" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "self").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => "self" ).length.should.equal 2
    
    # 'self' - Those that I own
    response = @ec2.describe_images( :owner_id => "self" )
    response[0].image_id.should.equal "ami-61a54008"
  end
  
  
  specify "should be able to be described by an owner of 'amazon' and return an array of Items that are Amazon Public AMI's" do
    @ec2.stubs(:make_request).with('DescribeImages', "Owner.1" => "amazon").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :owner_id => "amazon" ).length.should.equal 2
    
    # 'self' - Those that I own
    response = @ec2.describe_images( :owner_id => "amazon" )
    response[0].image_id.should.equal "ami-61a54008"
  end
  
  
  specify "should be able to be described by an owners with Owner.N ID's who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ExecutableBy.2" => "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] ).length.should.equal 2
    
    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => ["AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA", "ZZZZTLBUXIEON5NQVUUX6OMPWBZIZZZZ"] )
    response[0].image_id.should.equal "ami-61a54008"
    response[1].image_id.should.equal "ami-61a54009"
  end
  
  
  specify "should be able to be described by an owners with Owner.N of 'self' who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "self").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => "self" ).length.should.equal 2
    
    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => "self" )
    response[0].image_id.should.equal "ami-61a54008"
    response[1].image_id.should.equal "ami-61a54009"
  end
  
  
  specify "should be able to be described by an owners with Owner.N of 'all' who can execute AMI's and return an array of Items" do
    @ec2.stubs(:make_request).with('DescribeImages', "ExecutableBy.1" => "all").
      returns stub(:body => @describe_image_response_body, :is_a? => true)
    @ec2.describe_images( :executable_by => "all" ).length.should.equal 2
    
    # executable by owner ID's
    response = @ec2.describe_images( :executable_by => "all" )
    response[0].image_id.should.equal "ami-61a54008"
    response[1].image_id.should.equal "ami-61a54009"
  end
  
  
  specify "should be able to be de-registered" do
    @ec2.expects(:make_request).with('DeregisterImage', {"ImageId"=>"ami-61a54008"}).
      returns stub(:body => @deregister_image_response_body, :is_a? => true)
    @ec2.deregister_image(:image_id => "ami-61a54008" ).should.be.an.instance_of EC2::DeregisterImageResponse
  end
  
  
  specify "method deregister_image should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.deregister_image() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.deregister_image( :image_id => nil ) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.deregister_image( :image_id => "" ) }.should.raise(EC2::ArgumentError)
  end
  
  
end
