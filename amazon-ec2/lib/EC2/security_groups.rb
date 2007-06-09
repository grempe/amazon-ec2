# Amazon Web Services EC2 Query API Ruby library.  This library was 
# heavily modified from original Amazon Web Services sample code 
# and packaged as a Ruby Gem by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
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
    
# REMOVE
    
    #  class CreateSecurityGroupResponse < Response
    #    def parse
    #      # If we don't get an error, the creation succeeded.
    #      [["Security Group created."]]
    #    end
    #  end


    
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
    
# REMOVE

    #  class DescribeSecurityGroupsResponse < Response
    #    ELEMENT_XPATH = "DescribeSecurityGroupsResponse/securityGroupInfo/item"
    #    def parse
    #      doc = REXML::Document.new(@http_xml)
    #      lines = []
    #      
    #      doc.elements.each(ELEMENT_XPATH) do |rootelement|
    #        groupName = REXML::XPath.first(rootelement, "groupName").text
    #        ownerId = REXML::XPath.first(rootelement, "ownerId").text
    #        groupDescription = REXML::XPath.first(rootelement, "groupDescription").text
    #        lines << ["GROUP", ownerId, groupName, groupDescription]
    #        rootelement.elements.each("ipPermissions/item") do |element|
    #          ipProtocol = REXML::XPath.first(element, "ipProtocol").text
    #          fromPort = REXML::XPath.first(element, "fromPort").text
    #          toPort = REXML::XPath.first(element, "toPort").text
    #          permArr = [
    #                     "PERMISSION",
    #                     ownerId,
    #                     groupName,
    #                     "ALLOWS",
    #                     ipProtocol,
    #                     fromPort,
    #                     toPort,
    #                     "FROM"
    #                    ]
    #          element.elements.each("groups/item") do |subelement|
    #            userId = REXML::XPath.first(subelement, "userId").text
    #            targetGroupName = REXML::XPath.first(subelement, "groupName").text
    #            lines << permArr + ["USER", userId, "GRPNAME", targetGroupName]
    #          end
    #          element.elements.each("ipRanges/item") do |subelement|
    #            cidrIp = REXML::XPath.first(subelement, "cidrIp").text
    #            lines << permArr + ["CIDR", cidrIp]
    #          end
    #        end
    #      end
    #      lines
    #    end
    #  end


    
    # The DeleteSecurityGroup operation deletes a security group.
    # 
    # If an attempt is made to delete a security group and any 
    # instances exist that are members of that group a fault is 
    # returned.
    def delete_security_group(groupName)
      params = { "GroupName" => groupName }
      DeleteSecurityGroupResponse.new(make_request("DeleteSecurityGroup", params))
    end
    
# REMOVE

    #  class DeleteSecurityGroupResponse < Response
    #    def parse
    #      # If we don't get an error, the deletion succeeded.
    #      [["Security Group deleted."]]
    #    end
    #  end


    
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
    
# REMOVE

#  class AuthorizeSecurityGroupIngressResponse < Response
#    def parse
#      # If we don't get an error, the authorization succeeded.
#      [["Ingress authorized."]]
#    end
#  end


    
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
    
# REMOVE

#  class RevokeSecurityGroupIngressResponse < Response
#    def parse
#      # If we don't get an error, the revocation succeeded.
#      [["Ingress revoked."]]
#    end
#  end

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
