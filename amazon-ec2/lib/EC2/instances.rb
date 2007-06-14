#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Elastic Workbench, LLC
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

module EC2
  
  class AWSAuthConnection
    
    #Amazon Developer Guide Docs:
    #
    # The RunInstances operation launches a specified number of instances. 
    # 
    # Note : The Query version of RunInstances only allows instances of a single AMI to be launched in 
    # one call. This is different from the SOAP API call of the same name but similar to the 
    # ec2-run-instances command line tool. 
    # 
    # A call to RunInstances is guaranteed to start no fewer than the requested minimum. If there is 
    # insufficient capacity available then no instances will be started. Amazon EC2 will make a best effort 
    # attempt to satisfy the requested maximum values. 
    # 
    # Every instance is launched in a security group. This may be specified as part of the launch request. If a 
    # security group is not indicated then instances are started in a the default security group. 
    # An optional keypair ID may be provided for each image in the launch request. All instances that are 
    # created from images for which this is provided will have access to the associated public key at boot time 
    # (detailed below). This key may be used to provide secure access to an instance of an image on a 
    # per-instance basis. Amazon EC2 public images make use of this functionality to provide secure 
    # passwordless access to instances (and launching those images without a keypair ID will leave them 
    # inaccessible). 
    # 
    # The public key material is made available to the instance at boot time by placing it in a file named 
    # openssh_id.pub on a logical device that is exposed to the instance as /dev/sda2 (the ephemeral 
    # store). The format of this file is suitable for use as an entry within ~/.ssh/authorized_keys (the 
    # OpenSSH format). This can be done at boot time (as part of rclocal, for example) allowing for secure 
    # password-less access. As the need arises, other formats will also be considered.
    #
    #Required Arguments:
    #
    # :image_id => String (Default : "")
    # :min_count => Integer (default : 1 )
    # :max_count => Integer (default : 1 )
    #
    #Optional Arguments:
    #
    # :key_name => String (default : nil)
    # :group_id => Array (default : [])
    # :user_data => String (default : nil)
    # :addressing_type => String (default : "public")
    # :base64_encoded => Boolean (default : false)
    #
    def run_instances( options = {} )
      
      options = { :image_id => "",
                  :min_count => 1, 
                  :max_count => 1,
                  :key_name => nil,
                  :group_id => [],
                  :user_data => nil,
                  :addressing_type => "public",
                  :base64_encoded => false }.merge(options)
      
      # Do some validation on the arguments provided
      raise ArgumentError, ":image_id must be provided" if options[:image_id].nil? || options[:image_id].empty?
      raise ArgumentError, ":min_count is not valid" unless options[:min_count].to_i > 0
      raise ArgumentError, ":max_count is not valid" unless options[:max_count].to_i > 0
      raise ArgumentError, ":addressing_type must be 'direct' or 'public'" unless options[:addressing_type] == "public" || options[:addressing_type] == "direct"
      raise ArgumentError, ":base64_encoded must be 'true' or 'false'" unless options[:base64_encoded] == true || options[:base64_encoded] == false
      
      # If :user_data is passed in then URL escape and Base64 encode it
      # as needed.  Need for URL Escape + Base64 encoding is determined 
      # by :base64_encoded param.
      if options[:user_data]
        if options[:base64_encoded]
          user_data = options[:user_data]
        else
          user_data = Base64.encode64(options[:user_data]).gsub(/\n/,"").strip()
        end
      else
        user_data = nil
      end
      
      params = {
        "ImageId"  => options[:image_id],
        "MinCount" => options[:min_count].to_s,
        "MaxCount" => options[:max_count].to_s,
      }.merge(pathlist("SecurityGroup", options[:group_id])) 
      
      params["KeyName"] = options[:key_name] unless options[:key_name].nil? 
      params["UserData"] = user_data unless user_data.nil?
      
      return response_generator(:action => "RunInstances", :params => params)
      
    end
    
    
    #Amazon Developer Guide Docs:
    #
    # The DescribeInstances operation returns information about instances owned by the user 
    # making the request.
    #
    # An optional list of instance IDs may be provided to request information for those instances only. If no 
    # instance IDs are provided, information of all relevant instances information will be returned. If an 
    # instance is specified that does not exist a fault is returned. If an instance is specified that exists but is not 
    # owned by the user making the request, then that instance will not be included in the returned results. 
    # 
    # Recently terminated instances will be included in the returned results for a small interval subsequent to 
    # their termination. This interval is typically of the order of one hour
    #
    #Required Arguments:
    #
    # none
    #
    #Optional Arguments:
    #
    # :instance_id => String (default : [])
    #
    def describe_instances( options = {} )
      
      options = { :instance_id => [] }.merge(options)
      
      params = pathlist("InstanceId", options[:instance_id])
      
      return response_generator(:action => "DescribeInstances", :params => params)
      
    end
    
    
    #Amazon Developer Guide Docs:
    #
    # The RebootInstances operation requests a reboot of one or more instances. This operation is 
    # asynchronous; it only queues a request to reboot the specified instance(s). The operation will succeed 
    # provided the instances are valid and belong to the user. Terminated instances will be ignored.
    #
    #Required Arguments:
    #
    # :instance_id => Array (default : [])
    #
    #Optional Arguments:
    #
    # none
    #
    def reboot_instances( options = {} )
      
      options = { :instance_id => [] }.merge(options)
      
      raise ArgumentError, "No instance IDs provided" if options[:instance_id].nil? || options[:instance_id].empty?
      
      params = pathlist("InstanceId", options[:instance_id])
      
      return response_generator(:action => "RebootInstances", :params => params)
      
    end
    
    
    #Amazon Developer Guide Docs:
    #
    # The TerminateInstances operation shuts down one or more instances. This operation is idempotent 
    # and terminating an instance that is in the process of shutting down (or already terminated) will succeed. 
    # Terminated instances remain visible for a short period of time (approximately one hour) after 
    # termination, after which their instance ID is invalidated.
    #
    #Required Arguments:
    #
    # :instance_id => Array (default : [])
    #
    #Optional Arguments:
    #
    # none
    #
    def terminate_instances( options = {} )
      
      options = { :instance_id => [] }.merge(options)
      
      raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
      
      params = pathlist("InstanceId", options[:instance_id])
      
      return response_generator(:action => "TerminateInstances", :params => params)
      
    end
    
  end
  
end
