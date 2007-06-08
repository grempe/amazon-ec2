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
    def create_keypair(keyName="")
      raise ArgumentError, "No keyName provided" if keyName.empty?
      params = { "KeyName" => keyName }
      http_response = make_request("CreateKeyPair", params)
      http_xml = http_response.body
      doc = REXML::Document.new(http_xml)
      response = CreateKeyPairResponse.new
      response.key_name = REXML::XPath.first(doc, "CreateKeyPairResponse/keyName").text
      response.key_fingerprint = REXML::XPath.first(doc, "CreateKeyPairResponse/keyFingerprint").text
      response.key_material = REXML::XPath.first(doc, "CreateKeyPairResponse/keyMaterial").text
      return response
    end
    
    
    # The DescribeKeyPairs operation returns information about keypairs 
    # available for use by the user making the request. Selected keypairs 
    # may be specified or the list may be left empty if information for 
    # all registered keypairs is required.
    def describe_keypairs(keyNames=[])
      params = pathlist("KeyName", keyNames)
      describe_keypairs_response = DescribeKeyPairsResponseSet.new
      http_response = make_request("DescribeKeyPairs", params)
      http_xml = http_response.body
      doc = REXML::Document.new(http_xml)
      
      doc.elements.each("DescribeKeyPairsResponse/keySet/item") do |element|
        item = Item.new
        item.key_name = REXML::XPath.first(element, "keyName").text
        item.key_fingerprint = REXML::XPath.first(element, "keyFingerprint").text
        describe_keypairs_response << item
      end
      return describe_keypairs_response
    end
    
    
    # The DeleteKeyPair operation deletes a keypair.
    def delete_keypair(keyName="")
      raise ArgumentError, "No keyName provided" if keyName.empty?
      params = { "KeyName" => keyName }
      make_request("DeleteKeyPair", params)
      return response = DeleteKeyPairResponse.new
    end
    
  end
  
end
