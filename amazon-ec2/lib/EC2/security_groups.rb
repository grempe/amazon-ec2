# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
    
    # The CreateSecurityGroup operation creates a new security group.
    #
    # Every instance is launched in a security group. If none is specified 
    # as part of the launch request then instances are launched in the 
    # default security group. Instances within the same security group 
    # have unrestricted network access to one another. Instances will reject 
    # network access attempts from other instances in a different security 
    # group. As the owner of instances you may grant or revoke specific 
    # permissions using the AuthorizeSecurityGroupIngress and 
    # RevokeSecurityGroupIngress operations.
    def create_security_group(groupName, groupDescription)
      params = {
        "GroupName" => groupName,
        "GroupDescription" => groupDescription
      }
      CreateSecurityGroupResponse.new(make_request("CreateSecurityGroup", params))
    end
    
    # Maintain backward compatibility.  Changed method name from create_securitygroup
    # to more consistent name.
    alias create_securitygroup create_security_group
    
    # The DescribeSecurityGroups operation returns information about security 
    # groups owned by the user making the request.
    # 
    # An optional list of security group names may be provided to request 
    # information for those security groups only. If no security group 
    # names are provided, information of all security groups will be returned. 
    # If a group is specified that does not exist a fault is returned.
    def describe_security_groups(groupNames=[])
      params = pathlist("GroupName", groupNames)
      DescribeSecurityGroupsResponse.new(make_request("DescribeSecurityGroups", params))
    end
    
    # Maintain backward compatibility.  Changed method name from describe_securitygroups
    # to more consistent name.
    alias describe_securitygroups describe_security_groups
    
    # The DeleteSecurityGroup operation deletes a security group.
    # 
    # If an attempt is made to delete a security group and any 
    # instances exist that are members of that group a fault is 
    # returned.
    def delete_security_group(groupName)
      params = { "GroupName" => groupName }
      DeleteSecurityGroupResponse.new(make_request("DeleteSecurityGroup", params))
    end
    
    # Maintain backward compatibility.  Changed method name from delete_securitygroup
    # to more consistent name.
    alias delete_securitygroup delete_security_group
    
    # The AuthorizeSecurityGroupIngress operation adds permissions to a security 
    # group.
    #
    # Permissions are specified in terms of the IP protocol (TCP, UDP or ICMP), 
    # the source of the request (by IP range or an Amazon EC2 user-group pair), 
    # source and destination port ranges (for TCP and UDP), and ICMP codes and 
    # types (for ICMP). When authorizing ICMP, -1 may be used as a wildcard in 
    # the type and code fields.
    #
    # Permission changes are propagated to instances within the security group 
    # being modified as quickly as possible. However, a small delay is likely, 
    # depending on the number of instances that are members of the indicated group.
    #
    # When authorizing a user/group pair permission, GroupName, 
    # SourceSecurityGroupName and SourceSecurityGroupOwnerId must be specified. 
    # When authorizing a CIDR IP permission, GroupName, IpProtocol, FromPort, 
    # ToPort and CidrIp must be specified. Mixing these two types of parameters 
    # is not allowed.
    def authorize_security_group_ingress(*args)
      params = auth_revoke_impl(*args)
      AuthorizeSecurityGroupIngressResponse.new(make_request("AuthorizeSecurityGroupIngress", params))
    end
    
    # Maintain backward compatibility.  Changed method name from authorize
    # to more consistent name.
    alias authorize authorize_security_group_ingress
    
    # The RevokeSecurityGroupIngress operation revokes existing permissions 
    # that were previously granted to a security group. The permissions to 
    # revoke must be specified using the same values originally used to grant 
    # the permission.
    #
    # Permissions are specified in terms of the IP protocol (TCP, UDP or ICMP), 
    # the source of the request (by IP range or an Amazon EC2 user-group pair), 
    # source and destination port ranges (for TCP and UDP), and ICMP codes and 
    # types (for ICMP). When authorizing ICMP, -1 may be used as a wildcard 
    # in the type and code fields.
    #
    # Permission changes are propagated to instances within the security group 
    # being modified as quickly as possible. However, a small delay is likely, 
    # depending on the number of instances that are members of the indicated group.
    #
    # When revoking a user/group pair permission, GroupName, SourceSecurityGroupName 
    # and SourceSecurityGroupOwnerId must be specified. When authorizing a CIDR IP 
    # permission, GroupName, IpProtocol, FromPort, ToPort and CidrIp must be 
    # specified. Mixing these two types of parameters is not allowed.
    def revoke_security_group_ingress(*args)
      params = auth_revoke_impl(*args)
      RevokeSecurityGroupIngressResponse.new(make_request("RevokeSecurityGroupIngress", params))
    end
    
    # Maintain backward compatibility.  Changed method name from revoke
    # to more consistent name.
    alias revoke revoke_security_group_ingress
    
    private
    
      def auth_revoke_impl(groupName, kwargs={})
        in_params = { :ipProtocol=>nil, :fromPort=>nil, :toPort=>nil, :cidrIp=>nil, :sourceSecurityGroupName=>nil,
          :sourceSecurityGroupOwnerId=>nil}
        in_params.merge! kwargs
        
        { "GroupName" => in_params[:groupName] ,
          "IpProtocol" => in_params[:ipProtocol],
          "FromPort" => in_params[:fromPort].to_s,
          "ToPort" => in_params[:toPort].to_s, 
          "CidrIp" => in_params[:cidrIp], 
          "SourceSecurityGroupName" => in_params[:sourceSecurityGroupName],
          "SourceSecurityGroupOwnerId" => in_params[:sourceSecurityGroupOwnerId],
        }.reject { |key, value| value.nil? or value.empty?}
        
      end
    
  end
  
end
