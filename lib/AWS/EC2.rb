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
Dir[File.join(File.dirname(__FILE__), 'EC2/**/*.rb')].sort.each { |lib| require lib }

module AWS
  module EC2

    # Which host FQDN will we connect to for all API calls to AWS?
    # If EC2_URL is defined in the users ENV we can use that. It is
    # expected that this var is set with something like:
    #   export EC2_URL='https://ec2.amazonaws.com'
    #
    if ENV['EC2_URL']
      EC2_URL = ENV['EC2_URL']
      VALID_HOSTS = ['https://ec2.amazonaws.com', 'https://us-east-1.ec2.amazonaws.com', 'https://eu-west-1.ec2.amazonaws.com']
      raise ArgumentError, "Invalid EC2_URL environment variable : #{EC2_URL}" unless VALID_HOSTS.include?(EC2_URL)
      DEFAULT_HOST = URI.parse(EC2_URL).host
    else
      # default US host
      DEFAULT_HOST = 'ec2.amazonaws.com'
    end

    # This is the version of the API as defined by Amazon Web Services
    API_VERSION = '2008-12-01'

    #Introduction:
    #
    # The library exposes one main interface class, 'AWS::EC2::Base'.
    # This class provides all the methods for using the EC2 service
    # including the handling of header signing and other security issues .
    # This class uses Net::HTTP to interface with the EC2 Query API interface.
    #
    #Required Arguments:
    #
    # :access_key_id => String (default : "")
    # :secret_access_key => String (default : "")
    #
    #Optional Arguments:
    #
    # :use_ssl => Boolean (default : true)
    # :server => String (default : 'ec2.amazonaws.com')
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