module AWS
  module Autoscaling
    # Which host FQDN will we connect to for all API calls to AWS?
    # If AS_URL is defined in the users ENV we can override the default with that.
    #
    # @example
    #   export AS_URL='http://autoscaling.amazonaws.com'
    if ENV['AS_URL']
      AS_URL = ENV['AS_URL']
      DEFAULT_HOST = URI.parse(AS_URL).host
    else
      # Default US API endpoint
      DEFAULT_HOST = 'autoscaling.amazonaws.com'
    end

    API_VERSION = '2009-05-15'

    class Base < AWS::Base
      def api_version
        API_VERSION
      end

      def default_host
        DEFAULT_HOST
      end

      # Raises the appropriate error if the specified Net::HTTPResponse object
      # contains an Amazon EC2 error; returns +false+ otherwise.
      def aws_error?(response)

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
        unless doc.root.elements[1].name == "Error"
          raise Error, "Unexpected error format. response.body is: #{response.body}"
        end

        # An valid error response looks like this:
        # <?xml version="1.0"?><Response><Errors><Error><Code>InvalidParameterCombination</Code><Message>Unknown parameter: foo</Message></Error></Errors><RequestID>291cef62-3e86-414b-900e-17246eccfae8</RequestID></Response>
        # AWS EC2 throws some exception codes that look like Error.SubError.  Since we can't name classes this way
        # we need to strip out the '.' in the error 'Code' and we name the error exceptions with this
        # non '.' name as well.
        error_code    = doc.root.elements['//ErrorResponse/Error/Code'].text.gsub('.', '')
        error_message = doc.root.elements['//ErrorResponse/Error/Message'].text

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
end