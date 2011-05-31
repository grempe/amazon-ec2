module AWS
  module EC2
    class Base < AWS::Base


      # The CreateSecurityGroup operation creates a new security group. Every instance is launched
      # in a security group. If none is specified as part of the launch request then instances
      # are launched in the default security group. Instances within the same security group have
      # unrestricted network access to one another. Instances will reject network access attempts from other
      # instances in a different security group. As the owner of instances you may grant or revoke specific
      # permissions using the AuthorizeSecurityGroupIngress and RevokeSecurityGroupIngress operations.
      #
      # @option options [String] :group_name ("")
      # @option options [String] :group_description ("")
      #
      def create_security_group( options = {} )
        options = {:group_name => "",
                   :group_description => ""
                   }.merge(options)
        raise ArgumentError, "No :group_name provided" if options[:group_name].nil? || options[:group_name].empty?
        raise ArgumentError, "No :group_description provided" if options[:group_description].nil? || options[:group_description].empty?
        params = {
          "GroupName" => options[:group_name],
          "GroupDescription" => options[:group_description]
        }
        return response_generator(:action => "CreateSecurityGroup", :params => params)
      end


      # The DescribeSecurityGroups operation returns information about security groups owned by the
      # user making the request.
      #
      # An optional list of security group names may be provided to request information for those security
      # groups only. If no security group names are provided, information of all security groups will be
      # returned. If a group is specified that does not exist an exception is returned.
      #
      # @option options [optional, Array] :group_name ([])
      # @option options [optional, Array] :group_id ([])
      #
      def describe_security_groups( options = {} )
        options = { :group_name => [],
                    :group_id => [] }.merge(options)
        params = {}
        if options[:group_name]
          params.merge!(pathlist("GroupName", options[:group_name]))
        end
        if options[:group_id]
          params.merge!(pathlist("GroupId", options[:group_id]))
        end
        return response_generator(:action => "DescribeSecurityGroups", :params => params)
      end


      # The DeleteSecurityGroup operation deletes a security group.
      #
      # If an attempt is made to delete a security group and any instances exist that are members of that group a
      # fault is returned.
      #
      # @option options [String] :group_name ("")
      #
      def delete_security_group( options = {} )
        options ||= {}
        options = options.dup
        if (options[:group_id].nil? || options[:group_id].empty?) && (options[:group_name].nil? || options[:group_name].empty?)
          raise ArgumentError, "No :group_id or :group_name provided"
        end
        if !options[:group_id].nil? && !options[:group_id].empty? && !options[:group_name].nil? && !options[:group_name].empty?
          raise ArgumentError, ":group_id and :group_name both provided"
        end
        params = {}
        params["GroupId"] = options[:group_id] unless options[:group_id].nil? || options[:group_id].empty?
        params["GroupName"] = options[:group_name] unless options[:group_name].nil? || options[:group_name].empty?
        return response_generator(:action => "DeleteSecurityGroup", :params => params)
      end


      # The AuthorizeSecurityGroupIngress operation adds permissions to a security group.
      #
      # Permissions are specified in terms of the IP protocol (TCP, UDP or ICMP), the source of the request (by
      # IP range or an Amazon EC2 user-group pair), source and destination port ranges (for TCP and UDP),
      # and ICMP codes and types (for ICMP). When authorizing ICMP, -1 may be used as a wildcard in the
      # type and code fields.
      #
      # Permission changes are propagated to instances within the security group being modified as quickly as
      # possible. However, a small delay is likely, depending on the number of instances that are members of
      # the indicated group.
      #
      # When authorizing a user/group pair permission, GroupName, SourceSecurityGroupName and
      # SourceSecurityGroupOwnerId must be specified. When authorizing a CIDR IP permission,
      # GroupName, IpProtocol, FromPort, ToPort and CidrIp must be specified. Mixing these two types
      # of parameters is not allowed.
      #
      # @option options [require, String] :ip_protocol (nil) Required when authorizing CIDR IP permission
      # @option options [optional, String] :group_id ("")
      # @option options [optional, String] :group_name ("")
      # @option options [optional, Integer] :from_port (nil) Required when authorizing CIDR IP permission
      # @option options [optional, Integer] :to_port (nil) Required when authorizing CIDR IP permission
      # @option options [optional, String] :source_security_group_user_id (nil) Required when authorizing user group pair permissions
      # @option options [optional, String] :source_security_group_name (nil) Required when authorizing user group pair permissions
      # @option options [optional, String] :source_security_group_id (nil) ID of the source security group. Cannot be used when specifying a CIDR IP address. For VPC security groups only. Required if modifying access for one or more source security groups.
      # @option options [optional, String] :cidr_ip (nil) Required when authorizing CIDR IP permission
      #
      def authorize_security_group_ingress( options = {} )
        options = { :group_id => nil,
                    :group_name => nil,
                    :ip_protocol => nil,
                    :from_port => nil,
                    :to_port => nil,
                    :source_security_group_user_id => nil,
                    :source_security_group_name => nil,
                    :source_security_group_id => nil,
                    :cidr_ip => nil }.merge(options)

        if options[:ip_protocol].nil? || options[:ip_protocol].empty?
          raise ArgumentError, "No :ip_protocol provided"
        end

        # lets not validate the rest of the possible permutations of required params and instead let
        # EC2 sort it out on the server side.  We'll only require :group_id or :group_name as that is always needed.
        if (options[:group_id].nil? || options[:group_id].empty?) && (options[:group_name].nil? || options[:group_name].empty?)
          raise ArgumentError, "No :group_id or :group_name provided"
        end

        params = { "IpPermissions.1.IpProtocol" => options[:ip_protocol] }
        params['GroupId'] = options[:group_id] if options[:group_id]
        params['GroupName'] = options[:group_name] if options[:group_name]
        params["IpPermissions.1.FromPort"] = options[:from_port].to_s if options[:from_port]
        params["IpPermissions.1.ToPort"] = options[:to_port].to_s if options[:to_port]
        params["IpPermissions.1.Groups.1.UserId"] = options[:source_security_group_user_id] if options[:source_security_group_user_id]
        params["IpPermissions.1.Groups.1.GroupName"] = options[:source_security_group_name] if options[:source_security_group_name]
        params["IpPermissions.1.Groups.1.GroupId"] = options[:source_security_group_id] if options[:source_security_group_id]
        params["IpPermissions.1.IpRanges.1.CidrIp"] = options[:cidr_ip] if options[:cidr_ip]

        return response_generator(:action => "AuthorizeSecurityGroupIngress", :params => params)
      end


      # The RevokeSecurityGroupIngress operation revokes existing permissions that were previously
      # granted to a security group. The permissions to revoke must be specified using the same values
      # originally used to grant the permission.
      #
      # Permissions are specified in terms of the IP protocol (TCP, UDP or ICMP), the source of the request (by
      # IP range or an Amazon EC2 user-group pair), source and destination port ranges (for TCP and UDP),
      # and ICMP codes and types (for ICMP). When authorizing ICMP, -1 may be used as a wildcard in the
      # type and code fields.
      #
      # Permission changes are propagated to instances within the security group being modified as quickly as
      # possible. However, a small delay is likely, depending on the number of instances that are members of
      # the indicated group.
      #
      # When revoking a user/group pair permission, GroupName, SourceSecurityGroupName and
      # SourceSecurityGroupOwnerId must be specified. When authorizing a CIDR IP permission,
      # GroupName, IpProtocol, FromPort, ToPort and CidrIp must be specified. Mixing these two types
      # of parameters is not allowed.
      #
      # @option options [require, String] :ip_protocol (nil) Required when authorizing CIDR IP permission
      # @option options [optional, String] :group_id ("")
      # @option options [optional, String] :group_name ("")
      # @option options [optional, Integer] :from_port (nil) Required when authorizing CIDR IP permission
      # @option options [optional, Integer] :to_port (nil) Required when authorizing CIDR IP permission
      # @option options [optional, String] :source_security_group_user_id (nil) Required when authorizing user group pair permissions
      # @option options [optional, String] :source_security_group_name (nil) Required when authorizing user group pair permissions
      # @option options [optional, String] :source_security_group_id (nil) ID of the source security group. Cannot be used when specifying a CIDR IP address. For VPC security groups only. Required if modifying access for one or more source security groups.
      # @option options [optional, String] :cidr_ip (nil) Required when authorizing CIDR IP permission
      #
      def revoke_security_group_ingress( options = {} )
        options = { :group_id => nil,
                    :group_name => nil,
                    :ip_protocol => nil,
                    :from_port => nil,
                    :to_port => nil,
                    :cidr_ip => nil,
                    :source_security_group_name => nil,
                    :source_security_group_user_id => nil,
                    :source_security_group_id => nil }.merge(options)

        if options[:ip_protocol].nil? || options[:ip_protocol].empty?
          raise ArgumentError, "No :ip_protocol provided"
        end

        # lets not validate the rest of the possible permutations of required params and instead let
        # EC2 sort it out on the server side.  We'll only require :group_id or :group_name as that is always needed.
        if (options[:group_id].nil? || options[:group_id].empty?) && (options[:group_name].nil? || options[:group_name].empty?)
          raise ArgumentError, "No :group_id or :group_name provided"
        end

        params = { "IpPermissions.1.IpProtocol" => options[:ip_protocol] }
        params['GroupId'] = options[:group_id] if options[:group_id]
        params['GroupName'] = options[:group_name] if options[:group_name]
        params["IpPermissions.1.FromPort"] = options[:from_port].to_s if options[:from_port]
        params["IpPermissions.1.ToPort"] = options[:to_port].to_s if options[:to_port]
        params["IpPermissions.1.Groups.1.UserId"] = options[:source_security_group_user_id] if options[:source_security_group_user_id]
        params["IpPermissions.1.Groups.1.GroupName"] = options[:source_security_group_name] if options[:source_security_group_name]
        params["IpPermissions.1.Groups.1.GroupId"] = options[:source_security_group_id] if options[:source_security_group_id]
        params["IpPermissions.1.IpRanges.1.CidrIp"] = options[:cidr_ip] if options[:cidr_ip]

        return response_generator(:action => "RevokeSecurityGroupIngress", :params => params)
      end


    end
  end
end

