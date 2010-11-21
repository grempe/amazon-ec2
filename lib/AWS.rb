#--
# Amazon Web Services EC2 + ELB API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2009 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

%w[ base64 cgi openssl digest/sha1 net/https net/http rexml/document time ostruct ].each { |f| require f }

begin
  require 'URI' unless defined? URI
rescue Exception => e
  # nothing
end

begin
  require 'xmlsimple' unless defined? XmlSimple
rescue Exception => e
  require 'xml-simple' unless defined? XmlSimple
end


# A custom implementation of Hash that allows us to access hash values using dot notation
#
# @example Access the hash keys in the standard way or using dot notation
#   foo[:bar] => "baz"
#   foo.bar => "baz"
class Hash
  def method_missing(meth, *args, &block)
    if args.size == 0
      self[meth.to_s] || self[meth.to_sym]
    end
  end

  def type
    self['type']
  end

  def has?(key)
    self[key] && !self[key].to_s.empty?
  end

  def does_not_have?(key)
    self[key].nil? || self[key].to_s.empty?
  end
end


module AWS

  # Builds the canonical string for signing requests. This strips out all '&', '?', and '='
  # from the query string to be signed.  The parameters in the path passed in must already
  # be sorted in case-insensitive alphabetical order and must not be url encoded.
  #
  # @param [String] params the params that will be sorted and encoded as a canonical string.
  # @param [String] host the hostname of the API endpoint.
  # @param [String] method the HTTP method that will be used to submit the params.
  # @param [String] base the URI path that this information will be submitted to.
  # @return [String] the canonical request description string.
  def AWS.canonical_string(params, host, method="POST", base="/")
    # Sort, and encode parameters into a canonical string.
    sorted_params = params.sort {|x,y| x[0] <=> y[0]}
    encoded_params = sorted_params.collect do |p|
      encoded = (CGI::escape(p[0].to_s) +
                 "=" + CGI::escape(p[1].to_s))
      # Ensure spaces are encoded as '%20', not '+'
      encoded = encoded.gsub('+', '%20')
      # According to RFC3986 (the scheme for values expected by signing requests), '~' 
      # should not be encoded
      encoded = encoded.gsub('%7E', '~')
    end
    sigquery = encoded_params.join("&")

    # Generate the request description string
    req_desc =
      method + "\n" +
      host + "\n" +
      base + "\n" +
      sigquery

  end

  # Encodes the given string with the secret_access_key by taking the
  # hmac-sha1 sum, and then base64 encoding it.  Optionally, it will also
  # url encode the result of that to protect the string if it's going to
  # be used as a query string parameter.
  #
  # @param [String] secret_access_key the user's secret access key for signing.
  # @param [String] str the string to be hashed and encoded.
  # @param [Boolean] urlencode whether or not to url encode the result., true or false
  # @return [String] the signed and encoded string.
  def AWS.encode(secret_access_key, str, urlencode=true)
    digest = OpenSSL::Digest::Digest.new('sha256')
    b64_hmac =
      Base64.encode64(
        OpenSSL::HMAC.digest(digest, secret_access_key, str)).gsub("\n","")

    if urlencode
      return CGI::escape(b64_hmac)
    else
      return b64_hmac
    end
  end

  # This class provides all the methods for using the EC2 or ELB service
  # including the handling of header signing and other security concerns.
  # This class uses the Net::HTTP library to interface with the AWS Query API
  # interface. You should not instantiate this directly, instead
  # you should setup an instance of 'AWS::EC2::Base' or 'AWS::ELB::Base'.
  class Base

    attr_reader :use_ssl, :server, :proxy_server, :port

    # @option options [String] :access_key_id ("") The user's AWS Access Key ID
    # @option options [String] :secret_access_key ("") The user's AWS Secret Access Key
    # @option options [Boolean] :use_ssl (true) Connect using SSL?
    # @option options [String] :server ("ec2.amazonaws.com") The server API endpoint host
    # @option options [String] :proxy_server (nil) An HTTP proxy server FQDN
    # @return [Object] the object.
    def initialize( options = {} )

      options = { :access_key_id => "",
                  :secret_access_key => "",
                  :use_ssl => true,
                  :server => default_host,
                  :path => "/",
                  :proxy_server => nil
                  }.merge(options)

      @server = options[:server]
      @proxy_server = options[:proxy_server]
      @use_ssl = options[:use_ssl]
      @path = options[:path]

      raise ArgumentError, "No :access_key_id provided" if options[:access_key_id].nil? || options[:access_key_id].empty?
      raise ArgumentError, "No :secret_access_key provided" if options[:secret_access_key].nil? || options[:secret_access_key].empty?
      raise ArgumentError, "No :use_ssl value provided" if options[:use_ssl].nil?
      raise ArgumentError, "Invalid :use_ssl value provided, only 'true' or 'false' allowed" unless options[:use_ssl] == true || options[:use_ssl] == false
      raise ArgumentError, "No :server provided" if options[:server].nil? || options[:server].empty?

      if options[:port]
        # user-specified port
        @port = options[:port]
      elsif @use_ssl
        # https
        @port = 443
      else
        # http
        @port = 80
      end

      @access_key_id = options[:access_key_id]
      @secret_access_key = options[:secret_access_key]

      # Use proxy server if defined
      # Based on patch by Mathias Dalheimer.  20070217
      proxy = @proxy_server ? URI.parse(@proxy_server) : OpenStruct.new
      @http = Net::HTTP::Proxy( proxy.host,
                                proxy.port,
                                proxy.user,
                                proxy.password).new(options[:server], @port)

      @http.use_ssl = @use_ssl

      # Don't verify the SSL certificates.  Avoids SSL Cert warning in log on every GET.
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    end

    # If :user_data is passed in then URL escape and Base64 encode it
    # as needed.  Need for URL Escape + Base64 encoding is determined
    # by :base64_encoded param.
    def extract_user_data( options = {} )
      return unless options[:user_data]
      if options[:user_data]
        if options[:base64_encoded]
          Base64.encode64(options[:user_data]).gsub(/\n/, "").strip()
        else
          options[:user_data]
        end
      end
    end


    protected

      # pathlist is a utility method which takes a key string and and array as input.
      # It converts the array into a Hash with the hash key being 'Key.n' where
      # 'n' increments by 1 for each iteration.  So if you pass in args
      # ("ImageId", ["123", "456"]) you should get
      # {"ImageId.1"=>"123", "ImageId.2"=>"456"} returned.
      def pathlist(key, arr)
        params = {}

        # ruby 1.9 will barf if we pass in a string instead of the array expected.
        # it will fail on each_with_index below since string is not enumerable.
        if arr.is_a? String
          new_arr = []
          new_arr << arr
          arr = new_arr
        end

        arr.each_with_index do |value, i|
          params["#{key}.#{i+1}"] = value
        end
        params
      end

      # Same as _pathlist_ except it deals with arrays of hashes.
      # So if you pass in args
      # ("People", [{:name=>'jon', :age=>'22'}, {:name=>'chris'}], {:name => 'Name', :age => 'Age'}) you should get
      # {"People.1.Name"=>"jon", "People.1.Age"=>'22', 'People.2.Name'=>'chris'}
      def pathhashlist(key, arr_of_hashes, mappings)
        raise ArgumentError, "expected a key that is a String" unless key.is_a? String
        raise ArgumentError, "expected a arr_of_hashes that is an Array" unless arr_of_hashes.is_a? Array
        arr_of_hashes.each{|h| raise ArgumentError, "expected each element of arr_of_hashes to be a Hash" unless h.is_a?(Hash)}
        raise ArgumentError, "expected a mappings that is an Hash" unless mappings.is_a? Hash
        params = {}
        arr_of_hashes.each_with_index do |hash, i|
          hash.each do |attribute, value|
            if value.is_a? Array
              params["#{key}.#{i+1}.Name"] = mappings[attribute]
              value.each_with_index do |item, j|
                params["#{key}.#{i+1}.Value.#{j+1}"] = item.to_s
              end
            else
              params["#{key}.#{i+1}.#{mappings[attribute]}"] = value.to_s
            end
          end
        end
        params
      end

      # Same as _pathhashlist_ except it generates explicit <prefix>.Key= and <prefix>.Value or <prefix>.Value.1, <prefix>.Value.2
      # depending on whether the value is a scalar or an array.
      #
      # So if you pass in args
      # ("People", [{:name=>'jon'}, {:names=>['chris', 'bob']} with key_name = 'Key' and value_name = 'Value',
      # you should get
      # {"People.1.Key"=>"name", "People.1.Value"=>'jon', "People.2.Key"=>'names', 'People.2.Value.1'=>'chris', 'People.2.Value.2'=>'bob'}
      def pathkvlist(key, arr_of_hashes, key_name, value_name, mappings)
        raise ArgumentError, "expected a key that is a String" unless key.is_a? String
        raise ArgumentError, "expected a arr_of_hashes that is an Array" unless arr_of_hashes.is_a? Array
        arr_of_hashes.each{|h| raise ArgumentError, "expected each element of arr_of_hashes to be a Hash" unless h.is_a?(Hash)}
        raise ArgumentError, "expected a key_nam that is a String" unless key_name.is_a? String
        raise ArgumentError, "expected a value_name that is a String" unless value_name.is_a? String
        raise ArgumentError, "expected a mappings that is an Hash" unless mappings.is_a? Hash
        params = {}
        arr_of_hashes.each_with_index do |hash, i|
          hash.each do |attribute, value|
            params["#{key}.#{i+1}.#{key_name}"] = mappings.fetch(attribute, attribute)
            if !value.nil?
              if value.is_a? Array
                value.each_with_index do |item, j|
                  params["#{key}.#{i+1}.#{value_name}.#{j+1}"] = item.to_s
                end
              else
                params["#{key}.#{i+1}.#{value_name}"] = value.to_s
              end
            end
          end
        end
        params
      end

      # Make the connection to AWS EC2 passing in our request.  This is generally called from
      # within a 'Response' class object or one of its sub-classes so the response is interpreted
      # in its proper context.  See lib/EC2/responses.rb
      def make_request(action, params, data='')

        @http.start do

          # remove any keys that have nil or empty values
          params.reject! { |key, value| value.nil? or value.empty?}

          params.merge!( {"Action" => action,
                          "SignatureVersion" => "2",
                          "SignatureMethod" => 'HmacSHA256',
                          "AWSAccessKeyId" => @access_key_id,
                          "Version" => api_version,
                          "Timestamp"=>Time.now.getutc.iso8601} )

          sig = get_aws_auth_param(params, @secret_access_key, @server)

          query = params.sort.collect do |param|
            CGI::escape(param[0]) + "=" + CGI::escape(param[1])
          end.join("&") + "&Signature=" + sig

          req = Net::HTTP::Post.new(@path)
          req.content_type = 'application/x-www-form-urlencoded'
          req['User-Agent'] = "github-amazon-ec2-ruby-gem"

          response = @http.request(req, query)

          # Make a call to see if we need to throw an error based on the response given by EC2
          # All error classes are defined in EC2/exceptions.rb
          aws_error?(response)
          return response

        end

      end

      # Set the Authorization header using AWS signed header authentication
      def get_aws_auth_param(params, secret_access_key, server)
        canonical_string =  AWS.canonical_string(params, server,"POST", @path)
        encoded_canonical = AWS.encode(secret_access_key, canonical_string)
      end

      # allow us to have a one line call in each method which will do all of the work
      # in making the actual request to AWS.
      def response_generator( options = {} )

        options = {
          :action => "",
          :params => {}
        }.merge(options)

        raise ArgumentError, ":action must be provided to response_generator" if options[:action].nil? || options[:action].empty?

        http_response = make_request(options[:action], options[:params])
        http_xml = http_response.body

        return Response.parse(:xml => http_xml)
      end

      # Raises the appropriate error if the specified Net::HTTPResponse object
      # contains an AWS error; returns +false+ otherwise.
      def aws_error?(response)

        # return false if we got a HTTP 200 code,
        # otherwise there is some type of error (40x,50x) and
        # we should try to raise an appropriate exception
        # from one of our exception classes defined in
        # exceptions.rb
        return false if response.is_a?(Net::HTTPSuccess)

        raise AWS::Error, "Unexpected server error. response.body is: #{response.body}" if response.is_a?(Net::HTTPServerError)

        # parse the XML document so we can walk through it
        doc = REXML::Document.new(response.body)

        # Check that the Error element is in the place we would expect.
        # and if not raise a generic error exception
        unless doc.root.elements['Errors'].elements['Error'].name == 'Error'
          raise Error, "Unexpected error format. response.body is: #{response.body}"
        end

        # An valid error response looks like this:
        # <?xml version="1.0"?><Response><Errors><Error><Code>InvalidParameterCombination</Code><Message>Unknown parameter: foo</Message></Error></Errors><RequestID>291cef62-3e86-414b-900e-17246eccfae8</RequestID></Response>
        # AWS throws some exception codes that look like Error.SubError.  Since we can't name classes this way
        # we need to strip out the '.' in the error 'Code' and we name the error exceptions with this
        # non '.' name as well.
        error_code    = doc.root.elements['Errors'].elements['Error'].elements['Code'].text.gsub('.', '')
        error_message = doc.root.elements['Errors'].elements['Error'].elements['Message'].text

        # Raise one of our specific error classes if it exists.
        # otherwise, throw a generic EC2 Error with a few details.
        if AWS.const_defined?(error_code)
          raise AWS.const_get(error_code), error_message
        else
          raise AWS::Error, error_message
        end

      end

  end
end

Dir[File.join(File.dirname(__FILE__), 'AWS/**/*.rb')].sort.each { |lib| require lib }

