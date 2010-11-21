require File.dirname(__FILE__) + '/test_helper.rb'

context "Spot price history " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @describe_spot_price_history_response_body = <<-RESPONSE
    <DescribeSpotPriceHistoryResponse xmlns="http://ec2.amazonaws.com/doc/2009-11-30/">
      <spotPriceHistorySet>
        <item>
          <instanceType>m1.small</instanceType>
          <productDescription>Linux/UNIX</productDescription>
          <spotPrice>0.287</spotPrice>
          <timestamp>2009-12-04T20:56:05.000Z</timestamp>
        </item>
        <item>
          <instanceType>m1.small</instanceType>
          <productDescription>Windows</productDescription>
          <spotPrice>0.033</spotPrice>
          <timestamp>2009-12-04T22:33:47.000Z</timestamp>
        </item>
      </spotPriceHistorySet>
    </DescribeSpotPriceHistoryResponse>
    RESPONSE
  end

  specify "should be able to be listed" do
    @ec2.stubs(:make_request).with('DescribeSpotPriceHistory', {}).
      returns stub(:body => @describe_spot_price_history_response_body, :is_a? => true)
    @ec2.describe_spot_price_history().should.be.an.instance_of Hash
    @ec2.describe_spot_price_history().spotPriceHistorySet.item.should.be.an.instance_of Array
  end

  specify "should reject a start_time which is not a Time object" do
    lambda { @ec2.describe_spot_price_history(:start_time => "foo") }.should.raise(AWS::ArgumentError)
  end

  specify "should reject an end_time which is not a Time object" do
    lambda { @ec2.describe_spot_price_history(:end_time => 42) }.should.raise(AWS::ArgumentError)
  end

  specify "should be able to be requested with various instance types" do
    ["t1.micro", "m1.small", "m1.large", "m1.xlarge", "m2.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge", "cc1.4xlarge"].each do |type|
      @ec2.stubs(:make_request).with('DescribeSpotPriceHistory', {'InstanceType' => type}).
        returns stub(:body => @describe_spot_price_history_response_body, :is_a? => true)
      lambda { @ec2.describe_spot_price_history( :instance_type => type ) }.should.not.raise(AWS::ArgumentError)
    end
  end

  specify "should reject an invalid instance type" do
    lambda { @ec2.describe_spot_price_history(:instance_type => 'm1.tiny') }.should.raise(AWS::ArgumentError)
  end

  specify "should reject an invalid product description" do
    lambda { @ec2.describe_spot_price_history(:product_description => 'Solaris') }.should.raise(AWS::ArgumentError)
  end

end
