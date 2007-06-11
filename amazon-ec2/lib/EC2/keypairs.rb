# Amazon Web Services EC2 Query API Ruby library.  This library was 
# heavily modified from original Amazon Web Services sample code 
# and packaged as a Ruby Gem by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
    
    # The CreateKeyPair operation creates a new 2048 bit RSA keypair 
    # and returns a unique ID that can be used to reference this 
    # keypair when launching new instances.
    def create_keypair( options = {} )
      
      # defaults
      options = { :key_name => "" }.merge(options)
      
      raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?
      
      params = { "KeyName" => options[:key_name] }
      
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
    def describe_keypairs( options = {} )
      
      # defaults
      options = { :key_name => [] }.merge(options)
      
      params = pathlist("KeyName", options[:key_name] )
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
    def delete_keypair( options = {} )
      
      # defaults
      options = { :key_name => "" }.merge(options)
      
      raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?
      
      params = { "KeyName" => options[:key_name] }
      
      make_request("DeleteKeyPair", params)
      return response = DeleteKeyPairResponse.new
    end
    
  end
  
end
