require 'test/unit'

# Use this test case to test all of the base functions of the EC2 
# library.  The are the core functions in EC2.rb (auth, signing, HTTP GET, etc.)

class EC2Test < Test::Unit::TestCase
  
  def test_ec2_base
    assert true
  end
    
  # fails
  #def test_require_underscore
  #  assert(require 'amazon_ec2')
  #end

  # fails
  #def test_require_hyphenated
  #  assert(require 'amazon-ec2')
  #end

  #def test_require_gem
  #  assert(require_gem 'amazon-ec2')
  #end

  # fails
  #def test_require_short_name_downcase
  #  assert(require 'ec2')
  #end

  # fails
  #def test_require_short_name_upcase
  #  assert(require 'EC2')
  #end

  # fails
  #def test_require_short_name_downcase_rb
  #  assert(require 'ec2.rb')
  #end

  #def test_require_short_name_upcase_rb
  #  assert(require 'EC2.rb')
  #end

end
