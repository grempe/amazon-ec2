require "test_helper"

class TestResetResponse < Test::Unit::TestCase
  def setup
    body = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-03/">
        <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    @response = EC2::ResetInstancesResponse.new(stub(:body => body, :is_a? => true))
  end
  
  def test_parse
    assert_equal true, @response.parse
  end
end