require File.dirname(__FILE__) + '/test_helper.rb'

class TestEC2 < Test::Unit::TestCase
  
  def setup
    @ec2 = EC2::AWSAuthConnection.new('not a key', 'not a secret')
  end
  
  # IMAGE_ATTRIBUTES
  
  
  # IMAGES
  def test_register_image
  end
  
  def test_deregister_image
  end
  
  def test_describe_images
  end
  
  # INSTANCES
  def test_reboot_instances
    body = <<-RESPONSE
    <RebootInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2007-01-03/">
        <return>true</return>
    </RebootInstancesResponse>
    RESPONSE
    
    @ec2.expects(:make_request).with('RebootInstances', {"InstanceId.1"=>"i-2ea64347", "InstanceId.2"=>"i-21a64348"}).
          returns stub(:body => body, :is_a? => true)
    assert_equal true, @ec2.reboot_instances('i-2ea64347', 'i-21a64348')
  end
  
  
  # KEYPAIRS
  
  
  # RESPONSES
  
  
  # SECURITY GROUPS
  
  
  # VERSION
  
  
end
