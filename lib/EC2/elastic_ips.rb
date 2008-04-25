#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:grempe@rubyforge.org)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

module EC2

  class Base


    #Amazon Developer Guide Docs:
    #
    # The AllocateAddress operation acquires an elastic IP address for use with your account.
    #
    #Required Arguments:
    #
    # none
    #
    #Optional Arguments:
    #
    # none
    #
    def allocate_address

      return response_generator(:action => "AllocateAddress")

    end

    #Amazon Developer Guide Docs:
    #
    # The DescribeAddresses operation lists elastic IP addresses assigned to your account.
    #
    #Required Arguments:
    #
    # :public_ip => Array (default : [], can be empty)
    #
    #Optional Arguments:
    #
    # none
    #
    def describe_addresses( options = {} )

      options = { :public_ip => [] }.merge(options)

      params = pathlist("PublicIp", options[:public_ip])

      return response_generator(:action => "DescribeAddresses", :params => params)

    end

    #Amazon Developer Guide Docs:
    #
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
    #Required Arguments:
    #
    # :public_ip => String (default : '')
    #
    #Optional Arguments:
    #
    # none
    #
    def release_address( options = {} )

      options = { :public_ip => '' }.merge(options)

      raise ArgumentError, "No ':public_ip' provided" if options[:public_ip].nil? || options[:public_ip].empty?

      params = { "PublicIp" => options[:public_ip] }

      return response_generator(:action => "ReleaseAddress", :params => params)

    end

    #Amazon Developer Guide Docs:
    #
    # The AssociateAddress operation associates an elastic IP address with an instance.
    #
    # If the IP address is currently assigned to another instance, the IP address
    # is assigned to the new instance. This is an idempotent operation. If you enter
    # it more than once, Amazon EC2 does not return an error.
    #
    #Required Arguments:
    #
    # :instance_id  => String (default : '')
    # :public_ip    => String (default : '')
    #
    #Optional Arguments:
    #
    # none
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

    #Amazon Developer Guide Docs:
    #
    # The DisassociateAddress operation disassociates the specified elastic IP
    # address from the instance to which it is assigned. This is an idempotent
    # operation. If you enter it more than once, Amazon EC2 does not return
    # an error.
    #
    #Required Arguments:
    #
    # :public_ip    => String (default : '')
    #
    #Optional Arguments:
    #
    # none
    #
    def disassociate_address( options = {} )

      options = { :public_ip => '' }.merge(options)

      raise ArgumentError, "No ':public_ip' provided" if options[:public_ip].nil? || options[:public_ip].empty?

      params = { "PublicIp" => options[:public_ip] }

      return response_generator(:action => "DisassociateAddress", :params => params)

    end

  end

end
