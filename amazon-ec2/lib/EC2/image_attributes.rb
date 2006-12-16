# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( glenn @nospam@ elasticworkbench.com ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
    
    # The ModifyImageAttribute operation modifies an attribute of an AMI.
    #
    # Currently the only attribute supported is launchPermission. By 
    # modifying this attribute it is possible to make an AMI public or 
    # to grant specific users launch permissions for the AMI. To make the 
    # AMI public add the group=all attribute item. To grant launch permissions 
    # for a specific user add a userId=<userid> attribute item.
    def modify_image_attribute(imageId, attribute, operationType, attributeValueHash)
      params = {
        "ImageId" => imageId,
        "Attribute" => attribute,
        "OperationType" => operationType
      }
      if attribute == "launchPermission"
        params.merge!(pathlist("UserGroup", attributeValueHash[:userGroups])) if attributeValueHash.has_key? :userGroups
        params.merge!(pathlist("UserId", attributeValueHash[:userIds])) if attributeValueHash.has_key? :userIds
      end
      ModifyImageAttributeResponse.new(make_request("ModifyImageAttribute", params))
    end
    
    # The DescribeImageAttribute operation returns information about an attribute of an AMI.
    def describe_image_attribute(imageId, attribute)
      params = { "ImageId" => imageId, "Attribute" => attribute }
      DescribeImageAttributeResponse.new(make_request("DescribeImageAttribute", params))
    end
    
    # The ResetImageAttribute operation resets an attribute of an AMI to its default value.
    def reset_image_attribute(imageId, attribute)
      params = { "ImageId" => imageId, "Attribute" => attribute }
      ResetImageAttributeResponse.new(make_request("ResetImageAttribute", params))
    end
    
  end
  
end
