module AWS
  module EC2
    class Base < AWS::Base


      # The CreateKeyPair operation creates a new 2048 bit RSA keypair and returns a unique ID that can be
      # used to reference this keypair when launching new instances.
      #
      # @option options [String] :key_name ("")
      #
      def create_keypair( options = {} )
        options = { :key_name => "" }.merge(options)
        raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?
        params = { "KeyName" => options[:key_name] }
        return response_generator(:action => "CreateKeyPair", :params => params)
      end


      # The DescribeKeyPairs operation returns information about keypairs available for use by the user
      # making the request. Selected keypairs may be specified or the list may be left empty if information for
      # all registered keypairs is required.
      #
      # @option options [Array] :key_name ([])
      #
      def describe_keypairs( options = {} )
        options = { :key_name => [] }.merge(options)
        params = pathlist("KeyName", options[:key_name] )
        return response_generator(:action => "DescribeKeyPairs", :params => params)
      end


      # The DeleteKeyPair operation deletes a keypair.
      #
      # @option options [String] :key_name ("")
      #
      def delete_keypair( options = {} )
        options = { :key_name => "" }.merge(options)
        raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?
        params = { "KeyName" => options[:key_name] }
        return response_generator(:action => "DeleteKeyPair", :params => params)
      end


      # The ImportKeyPair operation upload a new RSA public key to the Amazon AWS.
      #
      # @option options [String] :key_name
      # @option options [String] :public_key_material
      #
      def import_keypair( options = {} )
        options = { :key_name => "", :public_key_material => "" }.merge(options)
        raise ArgumentError, "No :key_name provided" if options[:key_name].nil? || options[:key_name].empty?
        raise ArgumentError, "No :public_key_material provided" if options[:public_key_material].nil? || options[:public_key_material].empty?
        params = {
          "KeyName" => options[:key_name],
          "PublicKeyMaterial" => Base64.encode64(options[:public_key_material]).gsub(/\n/, "").strip
        }
        return response_generator(:action => "ImportKeyPair", :params => params)
      end


    end
  end
end

