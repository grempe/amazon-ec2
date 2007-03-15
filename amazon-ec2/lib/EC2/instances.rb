# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( glenn @nospam@ elasticworkbench.com ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
    
    # The RunInstances operation launches a specified number of instances.
    #
    # Note:
    #   The Query version of RunInstances only allows instances of a 
    #   single AMI to be launched in one call. This is different 
    #   from the SOAP API call of the same name but similar to the 
    #   ec2-run-instances command line tool.
    # 
    # A call to RunInstances is guaranteed to start no fewer than the 
    # requested minimum. If there is insufficient capacity available 
    # then no instances will be started. Amazon EC2 will make a best 
    # effort attempt to satisfy the requested maximum values.
    #
    # Every instance is launched in a security group. This may be 
    # specified as part of the launch request. If a security group is 
    # not indicated then instances are started in a the default security group.
    #
    # An optional keypair ID may be provided for each image in the launch 
    # request. All instances that are created from images for which this 
    # is provided will have access to the associated public key at boot 
    # time (detailed below). This key may be used to provide secure access 
    # to an instance of an image on a per-instance basis. Amazon EC2 public 
    # images make use of this functionality to provide secure passwordless 
    # access to instances (and launching those images without a keypair ID 
    # will leave them inaccessible).
    #
    # The public key material is made available to the instance at boot 
    # time by placing it in a file named openssh_id.pub on a logical 
    # device that is exposed to the instance as /dev/sda2 (the ephemeral store). 
    # The format of this file is suitable for use as an entry within 
    # ~/.ssh/authorized_keys (the OpenSSH format). This can be done at boot 
    # time (as part of rclocal, for example) allowing for secure 
    # password-less access. As the need arises, other formats will 
    # also be considered.
    def run_instances(imageId, kwargs={})
      
      # setup the default input parameters hash
      in_params = { :minCount=>1, :maxCount=>1, :keyname=>nil, :groupIds=>[], :userData=>nil, :base64Encoded=>false }
      
      # Override or extend the default input params with any passed in kwargs
      in_params.merge!(kwargs)
      
      # If userData is passed in then URL escape and Base64 encode it
      # as needed.  Need for URL Escape + Base64 encoding is determined 
      # by base64Encoded param.
      if in_params[:userData]
        if in_params[:base64Encoded]
          userData = in_params[:userData]
        else
          userData = CGI::escape(Base64.encode64(in_params[:userData]).gsub(/\n/,"").strip())
        end
      else
        userData = nil
      end

      params = {
        "ImageId"  => imageId,
        "MinCount" => in_params[:minCount].to_s,
        "MaxCount" => in_params[:maxCount].to_s,
      }.merge(pathlist("SecurityGroup", in_params[:groupIds])) 
      
      params["KeyName"] = in_params[:keyname] unless in_params[:keyname].nil? 
      params["UserData"] = userData unless userData.nil?

      RunInstancesResponse.new(make_request("RunInstances", params))
    end
    
    # The DescribeInstances operation returns information about instances owned 
    # by the user making the request.
    #
    # An optional list of instance IDs may be provided to request information 
    # for those instances only. If no instance IDs are provided, information of 
    # all relevant instances information will be returned. If an instance is 
    # specified that does not exist a fault is returned. If an instance is specified 
    # that exists but is not owned by the user making the request, then that 
    # instance will not be included in the returned results.
    #
    # Recently terminated instances will be included in the returned results 
    # for a small interval subsequent to their termination. This interval 
    # is typically of the order of one hour.
    def describe_instances(instanceIds=[])
      params = pathlist("InstanceId", instanceIds)
      DescribeInstancesResponse.new(make_request("DescribeInstances", params))
    end
    
    # The TerminateInstances operation shuts down one or more instances. 
    # This operation is idempotent and terminating an instance that is 
    # in the process of shutting down (or already terminated) will succeed.
    #
    # Terminated instances remain visible for a short period of time 
    # (approximately one hour) after termination, after which their 
    # instance ID is invalidated.
    def terminate_instances(instanceIds)
      params = pathlist("InstanceId", instanceIds)
      TerminateInstancesResponse.new(make_request("TerminateInstances", params))
    end
    
    # The RebootInstances operation requests a reboot of one or more instances. 
    # This operation is asynchronous; it only queues a request to reboot the specified 
    # instance(s). The operation will succeed provided the instances are valid and 
    # belong to the user. Terminated instances will be ignored.
    def reboot_instances(*instance_ids)
      raise "No instance ids given" if instance_ids.empty?
      params = pathlist("InstanceId", instance_ids)
      ResetInstancesResponse.new(make_request("RebootInstances", params))
    end
  end
  
end
