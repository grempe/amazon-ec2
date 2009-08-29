module AWS
  module Cloudwatch

    # Which host FQDN will we connect to for all API calls to AWS?
    # If ELB_URL is defined in the users ENV we can override the default with that.
    # 
    # @example
    #   export ELB_URL='https://montoring.amazonaws.com'
    if ENV['AWS_CLOUDWATCH_URL']
      ELB_URL = ENV['AWS_CLOUDWATCH_URL']
      VALID_HOSTS = ['monitoring.amazonaws.com']
      raise ArgumentError, "Invalid AWS_CLOUDWATCH_URL environment variable : #{AWS_CLOUDWATCH_URL}" unless VALID_HOSTS.include?(AWS_CLOUDWATCH_URL)
      DEFAULT_HOST = URI.parse(AWS_CLOUDWATCH_URL).host
    else
      # Default US API endpoint
      DEFAULT_HOST = 'elasticloadbalancing.amazonaws.com'
    end

    API_VERSION = '2009-05-15'

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