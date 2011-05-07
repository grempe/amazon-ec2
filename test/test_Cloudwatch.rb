require File.dirname(__FILE__) + '/test_helper.rb'

context "cloudwatch " do
  before do
    @cw = AWS::Cloudwatch::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @error_response_for_invalid_security_token = <<-RESPONSE
    <ErrorResponse xmlns="http://monitoring.amazonaws.com/doc/2009-05-15/">
      <Error>
        <Type>Sender</Type>
        <Code>InvalidClientTokenId</Code>
        <Message>The security token included in the request is invalid</Message>
      </Error>
      <RequestId>1e77e1bb-2920-11e0-80c8-b71648ee0b72</RequestId>
    </ErrorResponse>
    RESPONSE
  end

  specify "AWS::Cloudwatch::Base should give back a nice response if there is an error" do
    @cw.stubs(:make_request).with('ListMetrics', {}).returns stub(:body => @error_response_for_invalid_security_token, :is_a? => true)

    response = @cw.list_metrics
    response.should.be.an.instance_of Hash
    response["Error"]["Message"].should.equal "The security token included in the request is invalid"
  end

  specify "AWS::Cloudwatch::Base should take a next_token parameter" do
    @cw.expects(:make_request).with('ListMetrics', {'NextToken' => 'aaaaaaaaaa'}).returns stub(:body => @error_response_for_invalid_security_token)
    @cw.list_metrics(:next_token => 'aaaaaaaaaa')
  end
end
