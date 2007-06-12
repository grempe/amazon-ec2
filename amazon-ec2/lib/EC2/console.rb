# Amazon Web Services EC2 Query API Ruby library.  This library was 
# heavily modified from original Amazon Web Services sample code 
# and packaged as a Ruby Gem by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
#
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
  
    def get_console_output( options ={} )
      
      # defaults
      options = {:instance_id => ""}.merge(options)
      
      raise ArgumentError, "No instance ID provided" if options[:instance_id].nil? || options[:instance_id].empty?
      
      params = { "instanceId" => options[:instance_id] }
      http_response = make_request("GetConsoleOutput", params)
      http_xml = http_response.body
      return Response.parse(:xml => http_xml)
    end
  end
  
end