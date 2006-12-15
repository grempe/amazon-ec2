#  This software code is made available "AS IS" without warranties of any
#  kind.  You may copy, display, modify and redistribute the software
#  code either by itself or as incorporated into your code; provided that
#  you do not remove any proprietary notices.  Your use of this software
#  code is at your own risk and you waive any claim against Amazon Web
#  Services LLC or its affiliates with respect to your use of this software
#  code. (c) 2006 Amazon Web Services LLC or its affiliates.  All rights
#  reserved.

require 'base64'
require 'cgi'
require 'openssl'
require 'digest/sha1'
require 'net/https'
require 'rexml/document'
require 'time'

# Require any lib files that we have bundled with this Ruby Gem
Dir[File.join(File.dirname(__FILE__), 'EC2/**/*.rb')].sort.each { |lib| require lib }

include REXML

module EC2
  DEFAULT_HOST = 'ec2.amazonaws.com'
  PORTS_BY_SECURITY = { true => 443, false => 80 }
  API_VERSION = '2006-10-01'
  RELEASE_VERSION = "7813"
  
  # Builds the canonical string for signing.
  # Note:  The parameters in the path passed in must already be sorted in
  # case-insensitive alphabetical order and must not be url encoded.
  def EC2.canonical_string(path)
    buf = path.gsub(/\&|\?|=/,"")
  end

  # Encodes the given string with the aws_secret_access_key, by taking the
  # hmac-sha1 sum, and then base64 encoding it.  Optionally, it will also
  # url encode the result of that to protect the string if it's going to
  # be used as a query string parameter.
  def EC2.encode(aws_secret_access_key, str, urlencode=true)
    digest = OpenSSL::Digest::Digest.new('sha1')
    b64_hmac =
      Base64.encode64(
        OpenSSL::HMAC.digest(digest, aws_secret_access_key, str)).strip

    if urlencode
      return CGI::escape(b64_hmac)
    else
      return b64_hmac
    end
  end


  # uses Net::HTTP to interface with EC2.
  class AWSAuthConnection

    attr_accessor :verbose

    def initialize(aws_access_key_id, aws_secret_access_key, is_secure=true,
                   server=DEFAULT_HOST, port=PORTS_BY_SECURITY[is_secure])
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
      @http = Net::HTTP.new(server, port)
      @http.use_ssl = is_secure
      @verbose = false
    end

    def pathlist(key, arr)
      params = {}
      arr.each_with_index do |value, i|
        params["#{key}.#{i+1}"] = value
      end
      params
    end
    
    def register_image(imageLocation)
      params = { "ImageLocation" => imageLocation }
      RegisterImageResponse.new(make_request("RegisterImage", params))
    end
    
    def describe_images(imageIds=[], owners=[], executableBy=[])
      params = pathlist("ImageId", imageIds)
      params.merge!(pathlist("Owner", owners))
      params.merge!(pathlist("ExecutableBy", executableBy))
      DescribeImagesResponse.new(make_request("DescribeImages", params))
    end

    def deregister_image(imageId)
      params = { "ImageId" => imageId }
      DeregisterImageResponse.new(make_request("DeregisterImage", params))
    end

    def create_keypair(keyName)
      params = { "KeyName" => keyName }
      CreateKeyPairResponse.new(make_request("CreateKeyPair", params))
    end

    def describe_keypairs(keyNames=[])
      params = pathlist("KeyName", keyNames)
      DescribeKeyPairsResponse.new(make_request("DescribeKeyPairs", params))
    end

    def delete_keypair(keyName)
      params = { "KeyName" => keyName }
      DeleteKeyPairResponse.new(make_request("DeleteKeyPair", params))
    end

    def run_instances(imageId, kwargs={})
      in_params = { :minCount=>1, :maxCount=>1, :keyname=>nil, :groupIds=>[], :userData=>nil, :base64Encoded=>false }
      in_params.merge!(kwargs)
      userData = Base64.encode64(userData) if userData and not base64Encoded
      
      params = {
        "ImageId"  => imageId,
        "MinCount" => in_params[:minCount].to_s,
        "MaxCount" => in_params[:maxCount].to_s,
      }.merge(pathlist("SecurityGroup", in_params[:groupIds])) 

      params["KeyName"] = in_params[:keyname] unless in_params[:keyname].nil? 
        
      RunInstancesResponse.new(make_request("RunInstances", params))
    end

    def describe_instances(instanceIds=[])
      params = pathlist("InstanceId", instanceIds)
      DescribeInstancesResponse.new(make_request("DescribeInstances", params))
    end

    def terminate_instances(instanceIds)
      params = pathlist("InstanceId", instanceIds)
      TerminateInstancesResponse.new(make_request("TerminateInstances", params))
    end

    def create_securitygroup(groupName, groupDescription)
      params = {
        "GroupName" => groupName,
        "GroupDescription" => groupDescription
      }
      CreateSecurityGroupResponse.new(make_request("CreateSecurityGroup", params))
    end

    def describe_securitygroups(groupNames=[])
      params = pathlist("GroupName", groupNames)
      DescribeSecurityGroupsResponse.new(make_request("DescribeSecurityGroups", params))
    end

    def delete_securitygroup(groupName)
      params = { "GroupName" => groupName }
      DeleteSecurityGroupResponse.new(make_request("DeleteSecurityGroup", params))
    end

    def authorize(*args)
      params = auth_revoke_impl(*args)
      AuthorizeSecurityGroupIngressResponse.new(make_request("AuthorizeSecurityGroupIngress", params))
    end

    def revoke(*args)
      params = auth_revoke_impl(*args)
      RevokeSecurityGroupIngressResponse.new(make_request("RevokeSecurityGroupIngress", params))
    end

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

    def reset_image_attribute(imageId, attribute)
      params = { "ImageId" => imageId, "Attribute" => attribute }
      ResetImageAttributeResponse.new(make_request("ResetImageAttribute", params))
    end

    def describe_image_attribute(imageId, attribute)
      params = { "ImageId" => imageId, "Attribute" => attribute }
      DescribeImageAttributeResponse.new(make_request("DescribeImageAttribute", params))
    end

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
    
    private


    def make_request(action, params, data='')

      @http.start do

        params.merge!( {"Action"=>action, "SignatureVersion"=>"1", "AWSAccessKeyId"=>@aws_access_key_id,
                         "Version"=>API_VERSION, "Timestamp"=>Time.now.getutc.iso8601,} )
        p params if @verbose

        sigpath = "?" + params.sort_by { |param| param[0].downcase }.collect { |param| param.join("=") }.join("&")
        
        sig = get_aws_auth_param(sigpath, @aws_secret_access_key)
        
        path = "?" + params.sort.collect do |param|
          CGI::escape(param[0]) + "=" + CGI::escape(param[1])
        end.join("&") + "&Signature=" + sig
        
        puts path if @verbose
        
        req = Net::HTTP::Get.new("/#{path}")

        # ruby will automatically add a random content-type on some verbs, so
        # here we add a dummy one to 'supress' it.  change this logic if having
        # an empty content-type header becomes semantically meaningful for any
        # other verb.
        req['Content-Type'] ||= ''
        req['User-Agent'] = 'ec2-ruby-query 1.2-#{RELEASE_VERSION}'

        data = nil unless req.request_body_permitted?
        @http.request(req, data)

      end
    end
  
    # set the Authorization header using AWS signed header authentication
    def get_aws_auth_param(path, aws_secret_access_key)
      canonical_string =  EC2.canonical_string(path)
      encoded_canonical = EC2.encode(aws_secret_access_key, canonical_string)
    end
  end

  class Response
    attr_reader :http_response
    attr_reader :http_xml
    attr_reader :structure

    ERROR_XPATH = "Response/Errors/Error"
    
    def initialize(http_response)
      @http_response = http_response
      @http_xml = http_response.body
      @is_error = false
      if http_response.is_a? Net::HTTPSuccess
        @structure = parse
      else
        @is_error = true
        @structure = parse_error
      end
    end

    def is_error?
      @is_error
    end

    def parse_error
      doc = Document.new(@http_xml)
      element = XPath.first(doc, ERROR_XPATH)

      errorCode = XPath.first(element, "Code").text
      errorMessage = XPath.first(element, "Message").text

      [["#{errorCode}: #{errorMessage}"]]
    end

    def parse
      # Placeholder -- this method should be overridden in child classes.
      nil
    end

    def to_s
      @structure.collect do |line|
        line.join("\t")
      end.join("\n")
    end
  end

  class DescribeImagesResponse < Response
    ELEMENT_XPATH = "DescribeImagesResponse/imagesSet/item"
    def parse
      doc = Document.new(@http_xml)
      lines = []
      
      doc.elements.each(ELEMENT_XPATH) do |element|
        imageId = XPath.first(element, "imageId").text
        imageLocation = XPath.first(element, "imageLocation").text
        imageOwnerId = XPath.first(element, "imageOwnerId").text
        imageState = XPath.first(element, "imageState").text
        isPublic = XPath.first(element, "isPublic").text
        lines << ["IMAGE", imageId, imageLocation, imageOwnerId, imageState, isPublic]
      end
      lines
    end
  end

  class RegisterImageResponse < Response
    ELEMENT_XPATH = "RegisterImageResponse/imageId"
    def parse
      doc = Document.new(@http_xml)
      lines = [["IMAGE", XPath.first(doc, ELEMENT_XPATH).text]]
    end
  end

  class DeregisterImageResponse < Response
    def parse
      # If we don't get an error, the deregistration succeeded.
      [["Image deregistered."]]
    end
  end

  class CreateKeyPairResponse < Response
    ELEMENT_XPATH = "CreateKeyPairResponse"
    def parse
      doc = Document.new(@http_xml)
      element = XPath.first(doc, ELEMENT_XPATH)

      keyName = XPath.first(element, "keyName").text
      keyFingerprint = XPath.first(element, "keyFingerprint").text
      keyMaterial = XPath.first(element, "keyMaterial").text
      
      line = [["KEYPAIR", keyName, keyFingerprint], [keyMaterial]]
    end
  end

  class DescribeKeyPairsResponse < Response
    ELEMENT_XPATH = "DescribeKeyPairsResponse/keySet/item"
    def parse
      doc = Document.new(@http_xml)
      lines = []

      doc.elements.each(ELEMENT_XPATH) do |element|
        keyName = XPath.first(element, "keyName").text
        keyFingerprint = XPath.first(element, "keyFingerprint").text
        lines << ["KEYPAIR", keyName, keyFingerprint]
      end
      lines
    end
  end

  class DeleteKeyPairResponse < Response
    def parse
      # If we don't get an error, the deletion succeeded.
      [["Keypair deleted."]]
    end
  end

  class RunInstancesResponse < Response
    ELEMENT_XPATH = "RunInstancesResponse"
    def parse
      doc = Document.new(@http_xml)
      lines = []

      rootelement = XPath.first(doc, ELEMENT_XPATH)

      reservationId = XPath.first(rootelement, "reservationId").text
      ownerId = XPath.first(rootelement, "ownerId").text
      groups = nil
      rootelement.elements.each("groupSet/item/groupId") do |element|
        if not groups
          groups = element.text
        else
          groups += "," + element.text
        end
      end
      lines << ["RESERVATION", reservationId, ownerId, groups]

      #    rootelement = XPath.first(doc, ELEMENT_XPATH)
      rootelement.elements.each("instancesSet/item") do |element|
        instanceId = XPath.first(element, "instanceId").text
        imageId = XPath.first(element, "imageId").text
        instanceState = XPath.first(element, "instanceState/name").text
        # Only for debug mode, which we don't support yet:
        instanceStateCode = XPath.first(element, "instanceState/code").text
        dnsName = XPath.first(element, "dnsName").text
        # We don't return this, but still:
        reason = XPath.first(element, "reason").text
        lines << ["INSTANCE", instanceId, imageId, dnsName, instanceState]
      end
      lines
    end
  end

  class DescribeInstancesResponse < Response
    ELEMENT_XPATH = "DescribeInstancesResponse/reservationSet/item"
    def parse
      doc = Document.new(@http_xml)
      lines = []

      doc.elements.each(ELEMENT_XPATH) do |rootelement|
        reservationId = XPath.first(rootelement, "reservationId").text
        ownerId = XPath.first(rootelement, "ownerId").text
        groups = nil
        rootelement.elements.each("groupSet/item/groupId") do |element|
          if not groups
            groups = element.text
          else
            groups += "," + element.text
          end
        end
        lines << ["RESERVATION", reservationId, ownerId, groups]

        rootelement.elements.each("instancesSet/item") do |element|
          instanceId = XPath.first(element, "instanceId").text
          imageId = XPath.first(element, "imageId").text
          instanceState = XPath.first(element, "instanceState/name").text
          # Only for debug mode, which we don't support yet:
          instanceStateCode = XPath.first(element, "instanceState/code").text
          dnsName = XPath.first(element, "dnsName").text
          # We don't return this, but still:
          reason = XPath.first(element, "reason").text
          lines << ["INSTANCE", instanceId, imageId, dnsName, instanceState]
        end
      end
      lines
    end
  end

  class TerminateInstancesResponse < Response
    ELEMENT_XPATH = "TerminateInstancesResponse/instancesSet/item"
    def parse
      doc = Document.new(@http_xml)
      lines = []
      
      doc.elements.each(ELEMENT_XPATH) do |element|
        instanceId = XPath.first(element, "instanceId").text
        shutdownState = XPath.first(element, "shutdownState/name").text
        # Only for debug mode, which we don't support yet:
        shutdownStateCode = XPath.first(element, "shutdownState/code").text
        previousState = XPath.first(element, "previousState/name").text
        # Only for debug mode, which we don't support yet:
        previousStateCode = XPath.first(element, "previousState/code").text
        lines << ["INSTANCE", instanceId, previousState, shutdownState]
      end
      lines
    end
  end

  class CreateSecurityGroupResponse < Response
    def parse
      # If we don't get an error, the creation succeeded.
      [["Security Group created."]]
    end
  end

  class DescribeSecurityGroupsResponse < Response
    ELEMENT_XPATH = "DescribeSecurityGroupsResponse/securityGroupInfo/item"
    def parse
      doc = Document.new(@http_xml)
      lines = []
      
      doc.elements.each(ELEMENT_XPATH) do |rootelement|
        groupName = XPath.first(rootelement, "groupName").text
        ownerId = XPath.first(rootelement, "ownerId").text
        groupDescription = XPath.first(rootelement, "groupDescription").text
        lines << ["GROUP", ownerId, groupName, groupDescription]
        rootelement.elements.each("ipPermissions/item") do |element|
          ipProtocol = XPath.first(element, "ipProtocol").text
          fromPort = XPath.first(element, "fromPort").text
          toPort = XPath.first(element, "toPort").text
          permArr = [
                     "PERMISSION",
                     ownerId,
                     groupName,
                     "ALLOWS",
                     ipProtocol,
                     fromPort,
                     toPort,
                     "FROM"
                    ]
          element.elements.each("groups/item") do |subelement|
            userId = XPath.first(subelement, "userId").text
            targetGroupName = XPath.first(subelement, "groupName").text
            lines << permArr + ["USER", userId, "GRPNAME", targetGroupName]
          end
          element.elements.each("ipRanges/item") do |subelement|
            cidrIp = XPath.first(subelement, "cidrIp").text
            lines << permArr + ["CIDR", cidrIp]
          end
        end
      end
      lines
    end
  end

  class DeleteSecurityGroupResponse < Response
    def parse
      # If we don't get an error, the deletion succeeded.
      [["Security Group deleted."]]
    end
  end

  class AuthorizeSecurityGroupIngressResponse < Response
    def parse
      # If we don't get an error, the authorization succeeded.
      [["Ingress authorized."]]
    end
  end

  class RevokeSecurityGroupIngressResponse < Response
    def parse
      # If we don't get an error, the revocation succeeded.
      [["Ingress revoked."]]
    end
  end

  class ModifyImageAttributeResponse < Response
    def parse
      # If we don't get an error, modification succeeded.
      [["Image attribute modified."]]
    end
  end

  class ResetImageAttributeResponse < Response
    def parse
      # If we don't get an error, reset succeeded.
      [["Image attribute reset."]]
    end
  end

  class DescribeImageAttributeResponse < Response
    ELEMENT_XPATH = "DescribeImageAttributeResponse"
    def parse
      doc = Document.new(@http_xml)
      lines = []

      rootelement = XPath.first(doc, ELEMENT_XPATH)
      imageId = XPath.first(rootelement, "imageId").text
      
      # Handle launchPermission attributes:
      rootelement.elements.each("launchPermission/item/*") do |element|
        lines << [
                  "launchPermission",
                  imageId,
                  element.name,
                  element.text
                 ]
      end
      lines
    end
  end

end
