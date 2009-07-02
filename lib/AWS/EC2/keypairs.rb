#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

module AWS
  module EC2

    class Base < AWS::Base


      #Amazon Developer Guide Docs:
      #
      # The CreateKeyPair operation creates a new 2048 bit RSA keypair and returns a unique ID that can be
      # used to reference this keypair when launching new instances.
      #
      #Required Arguments:
      #
      # :key_name => String (default : "")
      #
      #Optional Arguments:
      #
      # none
      #
      def create_keypair( options = {} )

        # defaults
        options = { :key_name => "" }.merge(options)

        raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?

        params = { "KeyName" => options[:key_name] }

        return response_generator(:action => "CreateKeyPair", :params => params)

      end


      #Amazon Developer Guide Docs:
      #
      # The DescribeKeyPairs operation returns information about keypairs available for use by the user
      # making the request. Selected keypairs may be specified or the list may be left empty if information for
      # all registered keypairs is required.
      #
      #Required Arguments:
      #
      # :key_name => Array (default : [])
      #
      #Optional Arguments:
      #
      # none
      #
      def describe_keypairs( options = {} )

        options = { :key_name => [] }.merge(options)

        params = pathlist("KeyName", options[:key_name] )

        return response_generator(:action => "DescribeKeyPairs", :params => params)

      end


      #Amazon Developer Guide Docs:
      #
      # The DeleteKeyPair operation deletes a keypair.
      #
      #Required Arguments:
      #
      # :key_name => String (default : "")
      #
      #Optional Arguments:
      #
      # none
      #
      def delete_keypair( options = {} )

        options = { :key_name => "" }.merge(options)

        raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?

        params = { "KeyName" => options[:key_name] }

        return response_generator(:action => "DeleteKeyPair", :params => params)

      end

    end

  end
end