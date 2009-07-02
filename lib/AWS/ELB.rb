#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

# Require any lib files that we have bundled with this Ruby Gem in the lib/EC2 directory.
# Parts of the EC2 module and Base class are broken out into separate
# files for maintainability and are organized by the functional groupings defined
# in the EC2 API developers guide.
Dir[File.join(File.dirname(__FILE__), 'ELB/**/*.rb')].sort.each { |lib| require lib }

module AWS
  module ELB

    # Which host FQDN will we connect to for all API calls to AWS?
    # If ELB_URL is defined in the users ENV we can use that. It is
    # expected that this var is set with something like:
    #   export ELB_URL='https://ec2.amazonaws.com'
    #
    if ENV['ELB_URL']
      ELB_URL = ENV['ELB_URL']
      VALID_HOSTS = ['elasticloadbalancing.amazonaws.com']
      raise ArgumentError, "Invalid ELB_URL environment variable : #{ELB_URL}" unless VALID_HOSTS.include?(ELB_URL)
      DEFAULT_HOST = URI.parse(ELB_URL).host
    else
      # default US host
      DEFAULT_HOST = 'elasticloadbalancing.amazonaws.com'
    end

    # This is the version of the API as defined by Amazon Web Services
    API_VERSION = '2009-05-15'

    #Introduction:
    #
    # The library exposes one main interface class, 'AWS::ELB::Base'.
    # This class provides all the methods for using the ELB service
    # including the handling of header signing and other security issues .
    # This class uses Net::HTTP to interface with the ELB Query API interface.
    #
    #Required Arguments:
    #
    # :access_key_id => String (default : "")
    # :secret_access_key => String (default : "")
    #
    #Optional Arguments:
    #
    # :use_ssl => Boolean (default : true)
    # :server => String (default : 'elasticloadbalancing.amazonaws.com')
    # :proxy_server => String (default : nil)
    #
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