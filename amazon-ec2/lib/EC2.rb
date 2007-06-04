# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

# Original Amazon Web Services Notice
# This software code is made available "AS IS" without warranties of any
# kind.  You may copy, display, modify and redistribute the software
# code either by itself or as incorporated into your code; provided that
# you do not remove any proprietary notices.  Your use of this software
# code is at your own risk and you waive any claim against Amazon Web
# Services LLC or its affiliates with respect to your use of this software
# code. (c) 2006 Amazon Web Services LLC or its affiliates.  All rights
# reserved.

%w[ base64 cgi openssl digest/sha1 net/https rexml/document time ostruct ].each { |f| require f }

# Require any lib files that we have bundled with this Ruby Gem in the lib/EC2 directory.
# Parts of the EC2 module and AWSAuthConnection class are broken out into separate
# files for maintainability and are organized by the functional groupings defined 
# in the EC2 API developers guide.
Dir[File.join(File.dirname(__FILE__), 'EC2/**/*.rb')].sort.each { |lib| require lib }

module EC2
  
  # Which host FQDN will we connect to for all API calls to AWS?
  DEFAULT_HOST = 'ec2.amazonaws.com'
  
  # Define the ports to use for SSL(true) or Non-SSL(false) connections.
  PORTS_BY_SECURITY = { true => 443, false => 80 }
  
  # This is the version of the API as defined by Amazon Web Services
  API_VERSION = '2007-01-19'
  
  # This release version is passed in with each request as part
  # of the HTTP 'User-Agent' header.  Set this be the same value 
  # as what is stored in the lib/EC2/version.rb module constant instead.
  # This way we keep it nice and DRY and only have to define the 
  # version number in a single place. 
  RELEASE_VERSION = EC2::VERSION::STRING
  
  # Builds the canonical string for signing. This strips out all '&', '?', and '='
  # from the query string to be signed.
  #   Note:  The parameters in the path passed in must already be sorted in
  #   case-insensitive alphabetical order and must not be url encoded.
  def EC2.canonical_string(path)
    buf = ""
    path.split('&').each { |field|
      buf << field.gsub(/\&|\?/,"").sub(/=/,"")
    }
    return buf
  end
  
  # Encodes the given string with the aws_secret_access_key, by taking the
  # hmac-sha1 sum, and then base64 encoding it.  Optionally, it will also
  # url encode the result of that to protect the string if it's going to
  # be used as a query string parameter.
  def EC2.encode(aws_secret_access_key, str, urlencode=true)
    digest = OpenSSL::Digest::Digest.new('sha1')
    b64_hmac =
      Base64.encode64(
        OpenSSL::HMAC.digest(digest, aws_secret_access_key, str)).strip
        
    if urlencode
      return CGI::escape(b64_hmac)
    else
      return b64_hmac
    end
  end
  
  
  # The library exposes one main interface class, 'AWSAuthConnection'.
  # This class performs all the operations for using the EC2 service 
  # including header signing.  This class uses Net::HTTP to interface 
  # with EC2 Query API interface.
  class AWSAuthConnection
    
    def initialize(aws_access_key_id, aws_secret_access_key, is_secure=true,
                   server=DEFAULT_HOST, port=PORTS_BY_SECURITY[is_secure])
      
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
      @http = Net::HTTP.new(server, port)
      @http.use_ssl = is_secure
      # Don't verify the SSL certificates.  Avoids SSL Cert warning on every GET.
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      
    end
    
    
    private
      
      # pathlist is a utility method which takes a key string and and array as input.
      # It converts the array into a Hash with the hash key being 'Key.n' where
      # 'n' increments by 1 for each iteration.  So if you pass in args 
      # ("ImageId", ["123", "456"]) you should get 
      # {"ImageId.1"=>"123", "ImageId.2"=>"456"} returned.
      def pathlist(key, arr)
        params = {}
        arr.each_with_index do |value, i|
          params["#{key}.#{i+1}"] = value
        end
        params
      end
      
      
      # Make the connection to AWS EC2 passing in our request.  This is generally called from 
      # within a 'Response' class object or one of its sub-classes so the response is interpreted
      # in its proper context.  See lib/EC2/responses.rb
      def make_request(action, params, data='')
        
        @http.start do
          
          params.merge!( {"Action" => action,
                          "SignatureVersion" => "1",
                          "AWSAccessKeyId" => @aws_access_key_id,
                          "Version" => API_VERSION,
                          "Timestamp"=>Time.now.getutc.iso8601} )
          
          sigpath = "?" + params.sort_by { |param| param[0].downcase }.collect { |param| param.join("=") }.join("&")
          
          sig = get_aws_auth_param(sigpath, @aws_secret_access_key)
          
          path = "?" + params.sort.collect do |param|
            CGI::escape(param[0]) + "=" + CGI::escape(param[1])
          end.join("&") + "&Signature=" + sig
          
          req = Net::HTTP::Get.new("/#{path}")
          
          # Ruby will automatically add a random content-type on some verbs, so
          # here we add a dummy one to 'supress' it.  Change this logic if having
          # an empty content-type header becomes semantically meaningful for any
          # other verb.
          req['Content-Type'] ||= ''
          req['User-Agent'] = "rubyforge-amazon-ec2-ruby-gem-query-api v-#{RELEASE_VERSION}"
          
          #data = nil unless req.request_body_permitted?
          response = @http.request(req, nil)
          
          # Make a call to see if we need to throw an error based on the response given by EC2
          # All error classes are defined in exceptions.rb
          ec2_error?(response)
          
          return response
          
        end
        
      end
      
      # Set the Authorization header using AWS signed header authentication
      def get_aws_auth_param(path, aws_secret_access_key)
        canonical_string =  EC2.canonical_string(path)
        encoded_canonical = EC2.encode(aws_secret_access_key, canonical_string)
      end
      
      # Raises the appropriate error if the specified Net::HTTPResponse object
      # contains an Amazon EC2 error; returns +false+ otherwise.
      def ec2_error?(response)
        
        # return false if we got a HTTP 200 code,
        # otherwise there is some type of error (40x,50x) and
        # we should try to raise an appropriate exception
        # from one of our exception classes defined in
        # exceptions.rb
        return false if response.is_a?(Net::HTTPSuccess)

        # parse the XML document so we can walk through it
        doc = REXML::Document.new(response.body)
        
        # Check that the Error element is in the place we would expect.
        # and if not raise a generic error exception
        unless doc.root.elements['Errors'].elements['Error'].name == 'Error'
          raise Error, "Unexpected error format. response.body is: #{response.body}"
        end
        
        # An valid error response looks like this:
        # <?xml version="1.0"?><Response><Errors><Error><Code>InvalidParameterCombination</Code><Message>Unknown parameter: foo</Message></Error></Errors><RequestID>291cef62-3e86-414b-900e-17246eccfae8</RequestID></Response>
        # AWS EC2 throws some exception codes that look like Error.SubError.  Since we can't name classes this way
        # we need to strip out the '.' in the error 'Code' and we name the error exceptions with this
        # non '.' name as well.
        error_code    = doc.root.elements['Errors'].elements['Error'].elements['Code'].text.gsub('.', '')
        error_message = doc.root.elements['Errors'].elements['Error'].elements['Message'].text
        
        # Raise one of our specific error classes if it exists.
        # otherwise, throw a generic EC2 Error with a few details.
        if EC2.const_defined?(error_code)
          raise EC2.const_get(error_code), error_message
        else
          raise Error, "This is an undefined error code which needs to be added to exceptions.rb : error_code => #{error_code} : error_message => #{error_message}"
        end
        
      end
      
  end
  
end
