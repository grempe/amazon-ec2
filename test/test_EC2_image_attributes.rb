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

context "EC2 image_attributes " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @modify_image_attribute_response_body = <<-RESPONSE
    <ModifyImageAttributeResponse xm-lns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </ModifyImageAttributeResponse>
    RESPONSE

    @reset_image_attribute_response_body = <<-RESPONSE
    <ResetImageAttributeResponse xmlns="http://ec2.amazonaws.com/doc/2007-03-01">
      <return>true</return>
    </ResetImageAttributeResponse>
    RESPONSE

    @describe_image_attribute_response_body_launch_permissions = <<-RESPONSE
    <DescribeImageAttributeResponse xm-lns="http://ec2.amazonaws.com/doc/2007-03-01">
      <imageId>ami-61a54008</imageId>
      <launchPermission>
        <item>
          <group>all</group>
        </item>
        <item>
          <userId>495219933132</userId>
        </item>
      </launchPermission>
    </DescribeImageAttributeResponse>
    RESPONSE

    @describe_image_attribute_response_body_product_codes = <<-RESPONSE
    <DescribeImageAttributeResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-03">
      <imageId>ami-61a54008</imageId>
      <productCodes>
        <item>
          <productCode>774F4FF8</productCode>
        </item>
      </productCodes>
    </DescribeImageAttributeResponse>
    RESPONSE

  end


  specify "should be able to be changed with modify_image_attribute (with :attribute and single value :user_id and :group)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"launchPermission",
                                                            "OperationType"=>"add",
                                                            "UserId.1"=>"123",
                                                            "Group.1"=>"all"}).
       returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :user_id=>["123"], :group=>["all"]).should.be.an.instance_of Hash
  end


  specify "should be able to be changed with modify_image_attribute ( with :attribute but specifying :group only)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"launchPermission",
                                                            "OperationType"=>"add",
                                                            "Group.1"=>"all"}).
       returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :group=>["all"]).should.be.an.instance_of Hash
  end


  specify "should be able to be changed with modify_image_attribute ( with :operation_type 'remove')" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"launchPermission",
                                                            "OperationType"=>"remove",
                                                            "Group.1"=>"all"}).
       returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"remove", :group=>["all"]).should.be.an.instance_of Hash
  end


  specify "should be able to be changed with modify_image_attribute ( with :attribute but specifying :user_id only)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"launchPermission",
                                                            "OperationType"=>"add",
                                                            "UserId.1"=>"123"}).returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)

    @ec2.modify_image_attribute(:image_id=>"ami-61a54008",
                                :attribute=>"launchPermission",
                                :operation_type=>"add",
                                :user_id=>["123"]).should.be.an.instance_of Hash
  end


  specify "should be able to be changed with modify_image_attribute ( with :attribute=>'productCodes')" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"productCodes",
                                                            "OperationType"=>"",
                                                            "ProductCode.1"=>"774F4FF8"}).returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)

    @ec2.modify_image_attribute(:image_id=>"ami-61a54008",
                                :attribute=>"productCodes",
                                :product_code=>["774F4FF8"]).should.be.an.instance_of Hash
  end


  specify "should be able to be changed with modify_image_attribute ( with :attribute and multiple :user_id and :group elements)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"launchPermission",
                                                            "OperationType"=>"add",
                                                            "UserId.1"=>"123",
                                                            "UserId.2"=>"345",
                                                            "Group.1"=>"123",
                                                            "Group.2"=>"all"}).returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)

    @ec2.modify_image_attribute(:image_id=>"ami-61a54008",
                                :attribute=>"launchPermission",
                                :operation_type=>"add",
                                :user_id=>["123", "345"],
                                :group=>["123", "all"]).should.be.an.instance_of Hash
  end


  specify "should raise an exception when modify_image_attribute is called with incorrect arguments" do
    # method args can't be nil or empty
    lambda { @ec2.modify_image_attribute() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"") }.should.raise(AWS::ArgumentError)

    # :image_id option must be not be empty or nil
    lambda { @ec2.modify_image_attribute(:image_id=>nil, :attribute=>"launchPermission", :operation_type=>"add", :group=>["all"]) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"", :attribute=>"launchPermission", :operation_type=>"add", :group=>["all"]) }.should.raise(AWS::ArgumentError)

    # :attribute currently has two options which are 'launchPermission' and 'productCodes, it should fail with any other value, nil, or empty
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>nil, :operation_type=>"add", :group=>["all"]) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"", :operation_type=>"add", :group=>["all"]) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"foo", :operation_type=>"add", :group=>["all"]) }.should.raise(AWS::ArgumentError)

    # :attribute => 'launchPermission' option should fail if neither :group nor :user_id are also provided
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :group => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :group => "") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :user_id => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :user_id => "") }.should.raise(AWS::ArgumentError)

    # :attribute => 'productCodes' option should fail if :product_code isn't also provided
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"productCodes", :product_code=>nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"productCodes", :product_code=>"") }.should.raise(AWS::ArgumentError)

    # :operation_type currently has two options which are 'add' and 'remove', and it should fail with any other, nil or empty
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>nil, :group=>["all"]) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"", :group=>["all"]) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"foo", :group=>["all"]) }.should.raise(AWS::ArgumentError)
  end


  specify "method describe_image_attribute should return the proper attributes when called with launchPermission" do
    @ec2.stubs(:make_request).with('DescribeImageAttribute', {"ImageId"=>"ami-61a54008",
                                                              "Attribute"=>"launchPermission" }).
      returns stub(:body => @describe_image_attribute_response_body_launch_permissions, :is_a? => true)

    @ec2.describe_image_attribute(:image_id => "ami-61a54008", :attribute => "launchPermission").
      should.be.an.instance_of Hash

    response = @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission")
    response.imageId.should.equal "ami-61a54008"
    response.launchPermission.item[0].group.should.equal "all"
    response.launchPermission.item[1].userId.should.equal "495219933132"
  end


  specify "method describe_image_attribute should return the proper attributes when called with productCodes" do
    @ec2.stubs(:make_request).with('DescribeImageAttribute', {"ImageId"=>"ami-61a54008",
                                                              "Attribute"=>"productCodes" }).
      returns stub(:body => @describe_image_attribute_response_body_product_codes, :is_a? => true)

    @ec2.describe_image_attribute(:image_id => "ami-61a54008", :attribute => "productCodes").
      should.be.an.instance_of Hash

    response = @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"productCodes")
    response.imageId.should.equal "ami-61a54008"
    response.productCodes.item[0].productCode.should.equal "774F4FF8"
  end


  specify "should raise an exception when describe_image_attribute is called with incorrect arguments" do
    # method args can't be nil or empty
    lambda { @ec2.describe_image_attribute() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"") }.should.raise(AWS::ArgumentError)

    # :image_id option must be not be empty or nil w/ launchPermission
    lambda { @ec2.describe_image_attribute(:image_id=>nil, :attribute=>"launchPermission") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"", :attribute=>"launchPermission") }.should.raise(AWS::ArgumentError)

    # :image_id option must be not be empty or nil w/ productCodes
    lambda { @ec2.describe_image_attribute(:image_id=>nil, :attribute=>"productCodes") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"", :attribute=>"productCodes") }.should.raise(AWS::ArgumentError)

    # :attribute currently has two options which are 'launchPermission' and 'productCodes', it should fail with any other values,
    # nil, or empty
    lambda { @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"foo") }.should.raise(AWS::ArgumentError)
  end


  specify "should be able to reset attributes with reset_image_attribute " do
    @ec2.stubs(:make_request).with('ResetImageAttribute', {"ImageId"=>"ami-61a54008",
                                                            "Attribute"=>"launchPermission"}).
       returns stub(:body => @reset_image_attribute_response_body, :is_a? => true)
    @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission").should.be.an.instance_of Hash
    @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission").return.should.equal "true"
  end


  specify "should raise an exception when reset_image_attribute is called with incorrect arguments" do
    # method args can't be nil or empty
    lambda { @ec2.reset_image_attribute() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"") }.should.raise(AWS::ArgumentError)

    # :image_id option must be not be empty or nil
    lambda { @ec2.reset_image_attribute(:image_id=>nil, :attribute=>"launchPermission") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"", :attribute=>"launchPermission") }.should.raise(AWS::ArgumentError)

    # :attribute currently has one option which is 'launchPermission', it should fail with any other value, nil, or empty
    lambda { @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"") }.should.raise(AWS::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"foo") }.should.raise(AWS::ArgumentError)
  end


end
