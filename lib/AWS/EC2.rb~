module AWS
  module EC2

    # Which host FQDN will we connect to for all API calls to AWS?
    # If EC2_URL is defined in the users ENV we can override the default with that.
    #
    # @example
    #   export EC2_URL='https://ec2.amazonaws.com'
    if ENV['EC2_URL']
      EC2_URL = ENV['EC2_URL']
      DEFAULT_HOST = URI.parse(EC2_URL).host
    else
      # Default US API endpoint
      DEFAULT_HOST = 'ec2.amazonaws.com'
    end

    API_VERSION = '2010-08-31'

    class Base < AWS::Base
      def api_version
        API_VERSION
      end

      def default_host
        DEFAULT_HOST
      end
    end

  end
end

