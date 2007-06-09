require File.dirname(__FILE__) + '/test_helper.rb'

context "EC2 image_attributes " do
  
  setup do
    @ec2 = EC2::AWSAuthConnection.new( :aws_access_key_id => "not a key", :aws_secret_access_key => "not a secret" )
    
    @modify_image_attribute_response_body = <<-RESPONSE
    <ModifyImageAttributeResponse xm-lns="http://ec2.amazonaws.com/doc/2007-01-19">
      <return>true</return>
    </ModifyImageAttributeResponse>
    RESPONSE
    
    @reset_image_attribute_response_body = <<-RESPONSE
    <ResetImageAttributeResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-19"> 
      <return>true</return>
    </ResetImageAttributeResponse>
    RESPONSE
    
    @describe_image_attribute_response_body = <<-RESPONSE
    <DescribeImageAttributeResponse xm-lns="http://ec2.amazonaws.com/doc/2007-01-19">
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
    
  end
  
  
  specify "should be able to be changed with modify_image_attribute (with :attribute and single value :user_ids and :groups)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008", 
                                                            "Attribute"=>"launchPermission", 
                                                            "OperationType"=>"add",
                                                            "UserId.1"=>"123",
                                                            "Group.1"=>"all"}).
       returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :user_ids=>["123"], :groups=>["all"]).should.be.an.instance_of EC2::ModifyImageAttributeResponse
  end
  
  
  specify "should be able to be changed with modify_image_attribute ( with :attribute but specifying :groups only)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008", 
                                                            "Attribute"=>"launchPermission", 
                                                            "OperationType"=>"add",
                                                            "Group.1"=>"all"}).
       returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add", :groups=>["all"]).should.be.an.instance_of EC2::ModifyImageAttributeResponse
  end
  
  
  specify "should be able to be changed with modify_image_attribute ( with :operation_type 'remove')" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008", 
                                                            "Attribute"=>"launchPermission", 
                                                            "OperationType"=>"remove",
                                                            "Group.1"=>"all"}).
       returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"remove", :groups=>["all"]).should.be.an.instance_of EC2::ModifyImageAttributeResponse
  end
  
  
  specify "should be able to be changed with modify_image_attribute ( with :attribute but specifying :user_ids only)" do
    @ec2.stubs(:make_request).with('ModifyImageAttribute', {"ImageId"=>"ami-61a54008", 
                                                            "Attribute"=>"launchPermission", 
                                                            "OperationType"=>"add",
                                                            "UserId.1"=>"123"}).returns stub(:body => @modify_image_attribute_response_body, :is_a? => true)
                                                            
    @ec2.modify_image_attribute(:image_id=>"ami-61a54008", 
                                :attribute=>"launchPermission", 
                                :operation_type=>"add", 
                                :user_ids=>["123"]).should.be.an.instance_of EC2::ModifyImageAttributeResponse
  end
  
  
  specify "should be able to be changed with modify_image_attribute ( with :attribute and multiple :user_ids and :groups)" do
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
                                :user_ids=>["123", "345"], 
                                :groups=>["123", "all"]).should.be.an.instance_of EC2::ModifyImageAttributeResponse
  end
  
  
  specify "should raise an exception when modify_image_attribute is called with incorrect arguments" do
    # method args can't be nil or empty
    lambda { @ec2.modify_image_attribute() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"") }.should.raise(EC2::ArgumentError)
    
    # :image_id option must be not be empty or nil
    lambda { @ec2.modify_image_attribute(:image_id=>nil, :attribute=>"launchPermission", :operation_type=>"add", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"", :attribute=>"launchPermission", :operation_type=>"add", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    
    # :attribute currently has one option which is 'launchPermission', it should fail with any other value, nil, or empty
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>nil, :operation_type=>"add", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"", :operation_type=>"add", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"foo", :operation_type=>"add", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    
    # :attribute option should fail if neither :groups nor :user_ids are also provided
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"add") }.should.raise(EC2::ArgumentError)
    
    # :operation_type currently has two options which are 'add' and 'remove', and it should fail with any other, nil or empty
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>nil, :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.modify_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission", :operation_type=>"foo", :groups=>["all"]) }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "should be able to reset attributes with reset_image_attribute " do
    @ec2.stubs(:make_request).with('ResetImageAttribute', {"ImageId"=>"ami-61a54008", 
                                                            "Attribute"=>"launchPermission"}).
       returns stub(:body => @reset_image_attribute_response_body, :is_a? => true)
    @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission").should.be.an.instance_of EC2::ResetImageAttributeResponse
  end
  
  
  specify "should raise an exception when reset_image_attribute is called with incorrect arguments" do
    # method args can't be nil or empty
    lambda { @ec2.reset_image_attribute() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"") }.should.raise(EC2::ArgumentError)
    
    # :image_id option must be not be empty or nil
    lambda { @ec2.reset_image_attribute(:image_id=>nil, :attribute=>"launchPermission") }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"", :attribute=>"launchPermission") }.should.raise(EC2::ArgumentError)
    
    # :attribute currently has one option which is 'launchPermission', it should fail with any other value, nil, or empty
    lambda { @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>nil) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"") }.should.raise(EC2::ArgumentError)
    lambda { @ec2.reset_image_attribute(:image_id=>"ami-61a54008", :attribute=>"foo") }.should.raise(EC2::ArgumentError)
  end
  
  
  specify "method describe_image_attribute should return the proper attributes" do
    @ec2.stubs(:make_request).with('DescribeImageAttribute', {"ImageId"=>"ami-61a54008", 
                                                              "Attribute"=>"launchPermission" }).
      returns stub(:body => @describe_image_attribute_response_body, :is_a? => true)
    
    @ec2.describe_image_attribute(:image_id => "ami-61a54008", :attribute => "launchPermission")
    
    @ec2.describe_image_attribute(:image_id => "ami-61a54008", :attribute => "launchPermission").
      should.be.an.instance_of EC2::DescribeImageAttributeResponse
    
    response = @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"launchPermission")
    response.image_id.should.equal "ami-61a54008"
  end
  
  
  specify "should raise an exception when describe_image_attribute is called with incorrect arguments" do
    # method args can't be nil or empty
    lambda { @ec2.describe_image_attribute() }.should.raise(EC2::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"") }.should.raise(EC2::ArgumentError)
    
    # :image_id option must be not be empty or nil
    lambda { @ec2.describe_image_attribute(:image_id=>nil, :attribute=>"launchPermission") }.should.raise(EC2::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"", :attribute=>"launchPermission") }.should.raise(EC2::ArgumentError)
    
    # :attribute currently has one option which is 'launchPermission', it should fail with any other value, nil, or empty
    lambda { @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>nil) }.should.raise(EC2::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"") }.should.raise(EC2::ArgumentError)
    lambda { @ec2.describe_image_attribute(:image_id=>"ami-61a54008", :attribute=>"foo") }.should.raise(EC2::ArgumentError)
  end
  
  
end