require File.dirname(__FILE__) + '/test_helper.rb'

class TestEC2 < Test::Unit::TestCase
  
  def setup
    @conn = EC2::AWSAuthConnection.new('not a key', 'not a secret')
  end
  
  def test_reboot_instances
    body = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-03/">
        <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    
    @conn.expects(:make_request).with('RebootInstances', {"InstanceId.1"=>"i-2ea64347", "InstanceId.2"=>"i-21a64348"}).
          returns stub(:body => body, :is_a? => true)
    assert_equal true, @conn.reboot_instances('i-2ea64347', 'i-21a64348').parse
  end
  
end