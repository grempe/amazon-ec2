# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
  
    def get_console_output(instanceId="")
      raise ArgumentError, "No instance ID provided" if instanceId.empty?
      params = { "instanceId" => instanceId }
      http_response = make_request("GetConsoleOutput", params)
      http_xml = http_response.body
      doc = REXML::Document.new(http_xml)
      response = GetConsoleOutputResponse.new
      response.instance_id = REXML::XPath.first(doc, "GetConsoleOutputResponse/instanceId").text
      response.timestamp = REXML::XPath.first(doc, "GetConsoleOutputResponse/timestamp").text
      response.output = REXML::XPath.first(doc, "GetConsoleOutputResponse/output").text
      return response
    end
  end
  
end