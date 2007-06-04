# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  # The Response class is the superclass for all simple responses from method calls.
  # This is an OpenStruct object that will be returned so we can flexibly define the
  # members of this class when it is instantiated.
  class Response < OpenStruct
  end
  
  # Contains an array of Image objects
  class ImageList < Array
  end
  
  # Image is a Struct object which holds data representing a single machine Image
  # and provides all of the 'each' methods as it is Enumerable.
  #
  # An Image#to_hash utility method is also provided for convenience which can be used in
  # addition to the standard Image#to_a and Image#to_s methods.
  #
  # Remember that since this is a Struct object it does not have keys or indexes, but instead 'members'
  # and 'values'.  See the excellent tutorial on Struct and OpenStruct at http://errtheblog.com/post/30
  #
  class Image < Struct.new(:image_id, :image_location, :image_owner_id, :image_state, :is_public)
    
    def to_hash
      hash = Hash[*self.members.zip(self.values).flatten]
    end
    
  end
  
  # Contains an array of Instance objects
  class InstanceList < Array
  end
  
  # Instance is a Struct object which holds data representing a single running machine Instance
  # and provides all of the 'each' methods as it is Enumerable.
  #
  # An Instance#to_hash utility method is also provided for convenience which can be used in
  # addition to the standard Instance#to_a and Instance#to_s methods.
  #
  # Remember that since this is a Struct object it does not have keys or indexes, but instead 'members'
  # and 'values'.  See the excellent tutorial on Struct and OpenStruct at http://errtheblog.com/post/30
  #
  class Instance < Struct.new(:image_id, :image_location, :image_owner_id, :image_state, :is_public)
    
    def to_hash
      hash = Hash[*self.members.zip(self.values).flatten]
    end
    
  end
  
#  class DeregisterImageResponse < Response
#    def parse
#      # If we don't get an error, the deregistration succeeded.
#      [["Image deregistered."]]
#    end
#  end


#  class CreateKeyPairResponse < Response
#    ELEMENT_XPATH = "CreateKeyPairResponse"
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      element = REXML::XPath.first(doc, ELEMENT_XPATH)
#      
#      keyName = REXML::XPath.first(element, "keyName").text
#      keyFingerprint = REXML::XPath.first(element, "keyFingerprint").text
#      keyMaterial = REXML::XPath.first(element, "keyMaterial").text
#      
#      line = [["KEYPAIR", keyName, keyFingerprint], [keyMaterial]]
#    end
#  end


#  class DescribeKeyPairsResponse < Response
#    ELEMENT_XPATH = "DescribeKeyPairsResponse/keySet/item"
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      lines = []
#  
#      doc.elements.each(ELEMENT_XPATH) do |element|
#        keyName = REXML::XPath.first(element, "keyName").text
#        keyFingerprint = REXML::XPath.first(element, "keyFingerprint").text
#        lines << ["KEYPAIR", keyName, keyFingerprint]
#      end
#      lines
#    end
#  end


#  class DeleteKeyPairResponse < Response
#    def parse
#      # If we don't get an error, the deletion succeeded.
#      [["Keypair deleted."]]
#    end
#  end


#  class RunInstancesResponse < Response
#    ELEMENT_XPATH = "RunInstancesResponse"
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      lines = []
#      
#      rootelement = REXML::XPath.first(doc, ELEMENT_XPATH)
#      
#      reservationId = REXML::XPath.first(rootelement, "reservationId").text
#      ownerId = REXML::XPath.first(rootelement, "ownerId").text
#      groups = nil
#      rootelement.elements.each("groupSet/item/groupId") do |element|
#        if not groups
#          groups = element.text
#        else
#          groups += "," + element.text
#        end
#      end
#      lines << ["RESERVATION", reservationId, ownerId, groups]
#      
#      #    rootelement = REXML::XPath.first(doc, ELEMENT_XPATH)
#      rootelement.elements.each("instancesSet/item") do |element|
#        instanceId = REXML::XPath.first(element, "instanceId").text
#        imageId = REXML::XPath.first(element, "imageId").text
#        instanceState = REXML::XPath.first(element, "instanceState/name").text
#        # Only for debug mode, which we don't support yet:
#        instanceStateCode = REXML::XPath.first(element, "instanceState/code").text
#        dnsName = REXML::XPath.first(element, "dnsName").text
#        # We don't return this, but still:
#        reason = REXML::XPath.first(element, "reason").text
#        lines << ["INSTANCE", instanceId, imageId, dnsName, instanceState]
#      end
#      lines
#    end
#  end


#  class DescribeInstancesResponse < Response
#    ELEMENT_XPATH = "DescribeInstancesResponse/reservationSet/item"
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      lines = []
#      
#      doc.elements.each(ELEMENT_XPATH) do |rootelement|
#        reservationId = REXML::XPath.first(rootelement, "reservationId").text
#        ownerId = REXML::XPath.first(rootelement, "ownerId").text
#        groups = nil
#        rootelement.elements.each("groupSet/item/groupId") do |element|
#          if not groups
#            groups = element.text
#          else
#            groups += "," + element.text
#          end
#        end
#        lines << ["RESERVATION", reservationId, ownerId, groups]
#        
#        rootelement.elements.each("instancesSet/item") do |element|
#          instanceId = REXML::XPath.first(element, "instanceId").text
#          imageId = REXML::XPath.first(element, "imageId").text
#          instanceState = REXML::XPath.first(element, "instanceState/name").text
#          # Only for debug mode, which we don't support yet:
#          instanceStateCode = REXML::XPath.first(element, "instanceState/code").text
#          dnsName = REXML::XPath.first(element, "dnsName").text
#          # We don't return this, but still:
#          reason = REXML::XPath.first(element, "reason").text
#          lines << ["INSTANCE", instanceId, imageId, dnsName, instanceState]
#        end
#      end
#      lines
#    end
#  end


#  class TerminateInstancesResponse < Response
#    ELEMENT_XPATH = "TerminateInstancesResponse/instancesSet/item"
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      lines = []
#      
#      doc.elements.each(ELEMENT_XPATH) do |element|
#        instanceId = REXML::XPath.first(element, "instanceId").text
#        shutdownState = REXML::XPath.first(element, "shutdownState/name").text
#        # Only for debug mode, which we don't support yet:
#        shutdownStateCode = REXML::XPath.first(element, "shutdownState/code").text
#        previousState = REXML::XPath.first(element, "previousState/name").text
#        # Only for debug mode, which we don't support yet:
#        previousStateCode = REXML::XPath.first(element, "previousState/code").text
#        lines << ["INSTANCE", instanceId, previousState, shutdownState]
#      end
#      lines
#    end
#  end


#  class ResetInstancesResponse < Response
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      
#        # TODO : CONFIRM THIS COMMENT AND WHATS IN THE DOCS
#       # Let's use the tag they're actually returning since it doesn't match the docs -- Kevin Clark 2/26/07
#      REXML::XPath.match( doc, "//return").first.text == "true" ? true : false 
#    end
#  end


#  class CreateSecurityGroupResponse < Response
#    def parse
#      # If we don't get an error, the creation succeeded.
#      [["Security Group created."]]
#    end
#  end


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


#  class DeleteSecurityGroupResponse < Response
#    def parse
#      # If we don't get an error, the deletion succeeded.
#      [["Security Group deleted."]]
#    end
#  end


#  class AuthorizeSecurityGroupIngressResponse < Response
#    def parse
#      # If we don't get an error, the authorization succeeded.
#      [["Ingress authorized."]]
#    end
#  end


#  class RevokeSecurityGroupIngressResponse < Response
#    def parse
#      # If we don't get an error, the revocation succeeded.
#      [["Ingress revoked."]]
#    end
#  end


#  class ModifyImageAttributeResponse < Response
#    def parse
#      # If we don't get an error, modification succeeded.
#      [["Image attribute modified."]]
#    end
#  end


#  class ResetImageAttributeResponse < Response
#    def parse
#      # If we don't get an error, reset succeeded.
#      [["Image attribute reset."]]
#    end
#  end


#  class DescribeImageAttributeResponse < Response
#    ELEMENT_XPATH = "DescribeImageAttributeResponse"
#    def parse
#      doc = REXML::Document.new(@http_xml)
#      lines = []
#      
#      rootelement = REXML::XPath.first(doc, ELEMENT_XPATH)
#      imageId = REXML::XPath.first(rootelement, "imageId").text
#      
#      # Handle launchPermission attributes:
#      rootelement.elements.each("launchPermission/item/*") do |element|
#        lines << [
#                  "launchPermission",
#                  imageId,
#                  element.name,
#                  element.text
#                 ]
#      end
#      lines
#    end
#  end


# end EC2 Module
end

