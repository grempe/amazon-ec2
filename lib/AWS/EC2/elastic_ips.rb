module AWS
  module EC2
    class Base < AWS::Base


      # The AllocateAddress operation acquires an elastic IP address for use with your account.
      #
      def allocate_address
        return response_generator(:action => "AllocateAddress")
      end


      # The AssociateAddress operation associates an elastic IP address with an instance.
      #
      # If the IP address is currently assigned to another instance, the IP address
      # is assigned to the new instance. This is an idempotent operation. If you enter
      # it more than once, Amazon EC2 does not return an error.
      #
      # @option options [String] :instance_id ('') the instance ID to associate an IP with.
      # @option options [String] :public_ip ('') the public IP to associate an instance with.
      #
      def associate_address( options = {} )
        options = { :instance_id => '', :public_ip => '' }.merge(options)
        raise ArgumentError, "No ':instance_id' provided" if options[:instance_id].nil? || options[:instance_id].empty?
        raise ArgumentError, "No ':public_ip' provided" if options[:public_ip].nil? || options[:public_ip].empty?
        params = {
          "InstanceId" => options[:instance_id],
          "PublicIp" => options[:public_ip]
        }
        return response_generator(:action => "AssociateAddress", :params => params)
      end


      # The DescribeAddresses operation lists elastic IP addresses assigned to your account.
      #
      # @option options [Array] :public_ip ([]) an IP address to be described
      #
      def describe_addresses( options = {} )
        options = { :public_ip => [] }.merge(options)
        params = pathlist("PublicIp", options[:public_ip])
        return response_generator(:action => "DescribeAddresses", :params => params)
      end


      # The DisassociateAddress operation disassociates the specified elastic IP
      # address from the instance to which it is assigned. This is an idempotent
      # operation. If you enter it more than once, Amazon EC2 does not return
      # an error.
      #
      # @option options [String] :public_ip ('') the public IP to be dis-associated.
      #
      def disassociate_address( options = {} )
        options = { :public_ip => '' }.merge(options)
        raise ArgumentError, "No ':public_ip' provided" if options[:public_ip].nil? || options[:public_ip].empty?
        params = { "PublicIp" => options[:public_ip] }
        return response_generator(:action => "DisassociateAddress", :params => params)
      end


      # The ReleaseAddress operation releases an elastic IP address associated with your account.
      #
      # If you run this operation on an elastic IP address that is already released, the address
      # might be assigned to another account which will cause Amazon EC2 to return an error.
      #
      # Note : Releasing an IP address automatically disassociates it from any instance
      # with which it is associated. For more information, see DisassociateAddress.
      #
      # Important! After releasing an elastic IP address, it is released to the IP
      # address pool and might no longer be available to your account. Make sure
      # to update your DNS records and any servers or devices that communicate
      # with the address.
      #
      # @option options [String] :public_ip ('') an IP address to be released.
      #
      def release_address( options = {} )
        options = { :public_ip => '' }.merge(options)
        raise ArgumentError, "No ':public_ip' provided" if options[:public_ip].nil? || options[:public_ip].empty?
        params = { "PublicIp" => options[:public_ip] }
        return response_generator(:action => "ReleaseAddress", :params => params)
      end


    end
  end
end

