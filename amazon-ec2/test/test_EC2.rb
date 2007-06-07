require File.dirname(__FILE__) + '/test_helper.rb'

class TestEC2 < Test::Unit::TestCase
  
  def setup
    @ec2 = EC2::AWSAuthConnection.new('not a key', 'not a secret')
  end
  
  def test_register_image
  end
  
  def test_describe_images
  end
  
  def test_deregister_image
  end
  
end
