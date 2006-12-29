require 'test/unit'

class EC2Test < Test::Unit::TestCase
  
  def test_version
    assert_equal( "0.0.5", EC2::AWSAuthConnection::VERSION.to_s )
  end

end
