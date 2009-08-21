module AWS
  module ELB

    # Which host FQDN will we connect to for all API calls to AWS?
    # If ELB_URL is defined in the users ENV we can override the default with that.
    # 
    # @example
    #   export ELB_URL='https://elasticloadbalancing.amazonaws.com'
    if ENV['ELB_URL']
      ELB_URL = ENV['ELB_URL']
      VALID_HOSTS = ['elasticloadbalancing.amazonaws.com']
      raise ArgumentError, "Invalid ELB_URL environment variable : #{ELB_URL}" unless VALID_HOSTS.include?(ELB_URL)
      DEFAULT_HOST = URI.parse(ELB_URL).host
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