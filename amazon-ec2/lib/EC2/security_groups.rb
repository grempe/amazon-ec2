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
    def create_security_group( options = {} )
      
      # defaults
      options = {:group_name => "",
                 :group_description => ""
                 }.merge(options)
      
      raise ArgumentError, "No :group_name provided" if options[:group_name].nil? || options[:group_name].empty?
      raise ArgumentError, "No :group_description provided" if options[:group_description].nil? || options[:group_description].empty?
      
      params = {
        "GroupName" => options[:group_name],
        "GroupDescription" => options[:group_description]
      }
      
      http_response = make_request("CreateSecurityGroup", params)
      http_xml = http_response.body
      return Response.parse(:xml => http_xml)
      
    end
    
    
    # The DescribeSecurityGroups operation returns information about security 
    # groups owned by the user making the request.
    # 
    # An optional list of security group names may be provided to request 
    # information for those security groups only. If no security group 
    # names are provided, information of all security groups will be returned. 
    # If a group is specified that does not exist a fault is returned.
    def describe_security_groups( options = {} )
      
      # defaults
      options = { :group_name => [] }.merge(options)
      
      raise ArgumentError, "No :group_name provided" if options[:group_name] == ""
      raise ArgumentError, "No :group_name provided" if options[:group_name].nil?
      
      params = pathlist("GroupName", options[:group_name] )
      http_response = make_request("DescribeSecurityGroups", params)
      http_xml = http_response.body
      return Response.parse(:xml => http_xml)
    end
    
    
    # The DeleteSecurityGroup operation deletes a security group.
    # 
    # If an attempt is made to delete a security group and any 
    # instances exist that are members of that group a fault is 
    # returned.
    def delete_security_group( options = {} )
      
      # defaults
      options = { :group_name => "" }.merge(options)
      
      raise ArgumentError, "No :group_name provided" if options[:group_name].nil? || options[:group_name].empty?
      
      params = { "GroupName" => options[:group_name] }
      
      http_response = make_request("DeleteSecurityGroup", params)
      http_xml = http_response.body
      return Response.parse(:xml => http_xml)
      
    end
    
    
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
    def authorize_security_group_ingress( options = {} )
      
      # defaults
      options = { :group_name => nil,
                  :ip_protocol => nil,
                  :from_port => nil, 
                  :to_port => nil, 
                  :cidr_ip => nil, 
                  :source_security_group_name => nil,
                  :source_security_group_owner_id => nil }.merge(options)
      
      # lets not validate the rest of the possible permutations of required params and instead let
      # EC2 sort it out on the server side.  We'll only require :group_name as that is always needed.
      raise ArgumentError, "No :group_name provided" if options[:group_name].nil? || options[:group_name].empty?
      
      params = { "GroupName" => options[:group_name],
                 "IpProtocol" => options[:ip_protocol],
                 "FromPort" => options[:from_port].to_s,
                 "ToPort" => options[:to_port].to_s, 
                 "CidrIp" => options[:cidr_ip], 
                 "SourceSecurityGroupName" => options[:source_security_group_name],
                 "SourceSecurityGroupOwnerId" => options[:source_security_group_owner_id]
                 }
      
      http_response = make_request("AuthorizeSecurityGroupIngress", params)
      http_xml = http_response.body
      return Response.parse(:xml => http_xml)
      
    end
    
    
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
    def revoke_security_group_ingress( options = {} )
    
      # defaults
      options = { :group_name => nil,
                  :ip_protocol => nil,
                  :from_port => nil, 
                  :to_port => nil, 
                  :cidr_ip => nil, 
                  :source_security_group_name => nil,
                  :source_security_group_owner_id => nil }.merge(options)
      
      # lets not validate the rest of the possible permutations of required params and instead let
      # EC2 sort it out on the server side.  We'll only require :group_name as that is always needed.
      raise ArgumentError, "No :group_name provided" if options[:group_name].nil? || options[:group_name].empty?
      
      params = { "GroupName" => options[:group_name],
                 "IpProtocol" => options[:ip_protocol],
                 "FromPort" => options[:from_port].to_s,
                 "ToPort" => options[:to_port].to_s, 
                 "CidrIp" => options[:cidr_ip], 
                 "SourceSecurityGroupName" => options[:source_security_group_name],
                 "SourceSecurityGroupOwnerId" => options[:source_security_group_owner_id]
                 }
      
      http_response = make_request("RevokeSecurityGroupIngress", params)
      http_xml = http_response.body
      return Response.parse(:xml => http_xml)
      
    end
    
  end
  
end
