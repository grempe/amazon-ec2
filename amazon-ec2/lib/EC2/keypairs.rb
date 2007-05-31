# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
    
    # The CreateKeyPair operation creates a new 2048 bit RSA keypair 
    # and returns a unique ID that can be used to reference this 
    # keypair when launching new instances.
    def create_keypair(keyName)
      params = { "KeyName" => keyName }
      CreateKeyPairResponse.new(make_request("CreateKeyPair", params))
    end
    
    # The DescribeKeyPairs operation returns information about keypairs 
    # available for use by the user making the request. Selected keypairs 
    # may be specified or the list may be left empty if information for 
    # all registered keypairs is required.
    def describe_keypairs(keyNames=[])
      params = pathlist("KeyName", keyNames)
      DescribeKeyPairsResponse.new(make_request("DescribeKeyPairs", params))
    end
    
    # The DeleteKeyPair operation deletes a keypair.
    def delete_keypair(keyName)
      params = { "KeyName" => keyName }
      DeleteKeyPairResponse.new(make_request("DeleteKeyPair", params))
    end
    
  end
  
end
