module AWS
  module EC2
    class Base < AWS::Base

      # Launches a specified number of instances of an AMI for which you have permissions.
      #
      # Amazon API Docs : HTML[http://docs.amazonwebservices.com/AWSEC2/2009-10-31/APIReference/index.html?ApiReference-query-RunInstances.html]
      #
      # @option options [String] :image_id ("") Unique ID of a machine image.
      # @option options [Integer] :min_count (1) Minimum number of instances to launch. If the value is more than Amazon EC2 can launch, no instances are launched at all.
      # @option options [Integer] :max_count (1) Maximum number of instances to launch. If the value is more than Amazon EC2 can launch, the largest possible number above minCount will be launched instead.
      # @option options [optional, String] :key_name (nil) The name of the key pair.
      # @option options [optional, Array] :security_group (nil) Name of the security group(s). Array of Strings or String.
      # @option options [optional, String] :additional_info (nil) Specifies additional information to make available to the instance(s).
      # @option options [optional, String] :user_data (nil) MIME, Base64-encoded user data.
      # @option options [optional, String] :instance_type (nil) Specifies the instance type.
      # @option options [optional, String] :availability_zone (nil) Specifies the placement constraints (Availability Zones) for launching the instances.
      # @option options [optional, String] :kernel_id (nil) The ID of the kernel with which to launch the instance.
      # @option options [optional, String] :ramdisk_id (nil) The ID of the RAM disk with which to launch the instance. Some kernels require additional drivers at launch. Check the kernel requirements for information on whether you need to specify a RAM disk. To find kernel requirements, go to the Resource Center and search for the kernel ID.
      # @option options [optional, Array] :block_device_mapping ([]) An array of Hashes representing the elements of the block device mapping.  e.g. [{:device_name => '/dev/sdh', :virtual_name => '', :ebs_snapshot_id => '', :ebs_volume_size => '', :ebs_delete_on_termination => ''},{},...]
      # @option options [optional, Boolean] :monitoring_enabled (false) Enables monitoring for the instance.
      # @option options [optional, String] :subnet_id (nil) Specifies the Amazon VPC subnet ID within which to launch the instance(s) for Amazon Virtual Private Cloud.
      # @option options [optional, Boolean] :disable_api_termination (true) Specifies whether the instance can be terminated using the APIs. You must modify this attribute before you can terminate any "locked" instances from the APIs.
      # @option options [optional, String] :instance_initiated_shutdown_behavior ('stop') Specifies whether the instance's Amazon EBS volumes are stopped or terminated when the instance is shut down. Valid values : 'stop', 'terminate'
      # @option options [optional, Boolean] :base64_encoded (false)
      #
      def run_instances( options = {} )
        options = { :image_id => "",
                    :min_count => 1,
                    :max_count => 1,
                    :base64_encoded => false }.merge(options)

        raise ArgumentError, ":addressing_type has been deprecated." if options[:addressing_type]
        raise ArgumentError, ":group_id has been deprecated." if options[:group_id]

        raise ArgumentError, ":image_id must be provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, ":min_count is not valid" unless options[:min_count].to_i > 0
        raise ArgumentError, ":max_count is not valid or must be >= :min_count" unless options[:max_count].to_i > 0 && options[:max_count].to_i >= options[:min_count].to_i
        raise ArgumentError, ":instance_type must specify a valid instance type" unless options[:instance_type].nil? || ["t1.micro", "m1.small", "m1.large", "m1.xlarge", "m2.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge", "cc1.4xlarge"].include?(options[:instance_type])
        raise ArgumentError, ":monitoring_enabled must be 'true' or 'false'" unless options[:monitoring_enabled].nil? || [true, false].include?(options[:monitoring_enabled])
        raise ArgumentError, ":disable_api_termination must be 'true' or 'false'" unless options[:disable_api_termination].nil? || [true, false].include?(options[:disable_api_termination])
        raise ArgumentError, ":instance_initiated_shutdown_behavior must be 'stop' or 'terminate'" unless options[:instance_initiated_shutdown_behavior].nil? || ["stop", "terminate"].include?(options[:instance_initiated_shutdown_behavior])
        raise ArgumentError, ":base64_encoded must be 'true' or 'false'" unless [true, false].include?(options[:base64_encoded])

        user_data = extract_user_data(options)

        params = {}

        if options[:security_group]
          params.merge!(pathlist("SecurityGroup", options[:security_group]))
        end

        if options[:block_device_mapping]
          params.merge!(pathhashlist('BlockDeviceMapping', options[:block_device_mapping].flatten, {:device_name => 'DeviceName', :virtual_name => 'VirtualName', :ebs_snapshot_id => 'Ebs.SnapshotId', :ebs_volume_size => 'Ebs.VolumeSize', :ebs_delete_on_termination => 'Ebs.DeleteOnTermination' }))
        end

        params["ImageId"]                           = options[:image_id]
        params["MinCount"]                          = options[:min_count].to_s
        params["MaxCount"]                          = options[:max_count].to_s
        params["KeyName"]                           = options[:key_name] unless options[:key_name].nil?
        params["AdditionalInfo"]                    = options[:additional_info] unless options[:additional_info].nil?
        params["UserData"]                          = user_data unless user_data.nil?
        params["InstanceType"]                      = options[:instance_type] unless options[:instance_type].nil?
        params["Placement.AvailabilityZone"]        = options[:availability_zone] unless options[:availability_zone].nil?
        params["KernelId"]                          = options[:kernel_id] unless options[:kernel_id].nil?
        params["RamdiskId"]                         = options[:ramdisk_id] unless options[:ramdisk_id].nil?
        params["Monitoring.Enabled"]                = options[:monitoring_enabled].to_s unless options[:monitoring_enabled].nil?
        params["SubnetId"]                          = options[:subnet_id] unless options[:subnet_id].nil?
        params["DisableApiTermination"]             = options[:disable_api_termination].to_s unless options[:disable_api_termination].nil?
        params["InstanceInitiatedShutdownBehavior"] = options[:instance_initiated_shutdown_behavior] unless options[:instance_initiated_shutdown_behavior].nil?

        return response_generator(:action => "RunInstances", :params => params)
      end

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
      # @option options [Array] :instance_id ([])
      #
      def describe_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        params = pathlist("InstanceId", options[:instance_id])
        return response_generator(:action => "DescribeInstances", :params => params)
      end


      # Returns information about an attribute of an instance.
      #
      # @option options [String] :instance_id (nil) ID of the instance on which the attribute will be queried.
      # @option options [String] :attribute (nil) Specifies the attribute to query..
      #
      def describe_instance_attribute( options = {} )
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        raise ArgumentError, "No :attribute provided" if options[:attribute].nil? || options[:attribute].empty?
        valid_attributes = %w(instanceType kernel ramdisk userData disableApiTermination instanceInitiatedShutdownBehavior rootDevice blockDeviceMapping)
        raise ArgumentError, "Invalid :attribute provided" unless valid_attributes.include?(options[:attribute].to_s)
        params = {}
        params["InstanceId"] =  options[:instance_id]
        params["Attribute"] =  options[:attribute]
        return response_generator(:action => "DescribeInstanceAttribute", :params => params)
      end


      # Modifies an attribute of an instance.
      #
      # @option options [String] :instance_id (nil) ID of the instance on which the attribute will be modified.
      # @option options [String] :attribute (nil) Specifies the attribute to modify.
      # @option options [String] :value (nil) The value of the attribute being modified.
      #
      def modify_instance_attribute( options = {} )
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        raise ArgumentError, "No :attribute provided" if options[:attribute].nil? || options[:attribute].empty?
        raise ArgumentError, "No :value provided" if options[:value].nil?
        valid_attributes = %w(instanceType kernel ramdisk userData disableApiTermination instanceInitiatedShutdownBehavior rootDevice blockDeviceMapping)
        raise ArgumentError, "Invalid :attribute provided" unless valid_attributes.include?(options[:attribute].to_s)
        params = {}
        params["InstanceId"] =  options[:instance_id]
        params["Attribute"] =  options[:attribute]
        params["Value"] =  options[:value].to_s
        return response_generator(:action => "ModifyInstanceAttribute", :params => params)
      end


      # Resets an attribute of an instance to its default value.
      #
      # @option options [String] :instance_id (nil) ID of the instance on which the attribute will be reset.
      # @option options [String] :attribute (nil) The instance attribute to reset to the default value.
      #
      def reset_instance_attribute( options = {} )
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        raise ArgumentError, "No :attribute provided" if options[:attribute].nil? || options[:attribute].empty?
        valid_attributes = %w(kernel ramdisk)
        raise ArgumentError, "Invalid :attribute provided" unless valid_attributes.include?(options[:attribute].to_s)
        params = {}
        params["InstanceId"] =  options[:instance_id]
        params["Attribute"] =  options[:attribute]
        return response_generator(:action => "ResetInstanceAttribute", :params => params)
      end


      # Starts an instance that uses an Amazon EBS volume as its root device.
      #
      # @option options [Array] :instance_id ([]) Array of unique instance ID's of stopped instances.
      #
      def start_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = {}
        params.merge!(pathlist("InstanceId", options[:instance_id]))
        return response_generator(:action => "StartInstances", :params => params)
      end


      # Stops an instance that uses an Amazon EBS volume as its root device.
      #
      # @option options [Array] :instance_id ([]) Unique instance ID of a running instance.
      # @option options [optional, Boolean] :force (false) Forces the instance to stop. The instance will not have an opportunity to flush file system caches nor file system meta data. If you use this option, you must perform file system check and repair procedures. This option is not recommended for Windows instances.
      #
      def stop_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        raise ArgumentError, ":force must be 'true' or 'false'" unless options[:force].nil? || [true, false].include?(options[:force])
        params = {}
        params.merge!(pathlist("InstanceId", options[:instance_id]))
        params["Force"] = options[:force].to_s unless options[:force].nil?
        return response_generator(:action => "StopInstances", :params => params)
      end


      # The RebootInstances operation requests a reboot of one or more instances. This operation is
      # asynchronous; it only queues a request to reboot the specified instance(s). The operation will succeed
      # provided the instances are valid and belong to the user. Terminated instances will be ignored.
      #
      # @option options [Array] :instance_id ([])
      #
      def reboot_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        raise ArgumentError, "No instance IDs provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = pathlist("InstanceId", options[:instance_id])
        return response_generator(:action => "RebootInstances", :params => params)
      end


      # The TerminateInstances operation shuts down one or more instances. This operation is idempotent
      # and terminating an instance that is in the process of shutting down (or already terminated) will succeed.
      # Terminated instances remain visible for a short period of time (approximately one hour) after
      # termination, after which their instance ID is invalidated.
      #
      # @option options [Array] :instance_id ([])
      #
      def terminate_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = pathlist("InstanceId", options[:instance_id])
        return response_generator(:action => "TerminateInstances", :params => params)
      end


      # The MonitorInstances operation tells Cloudwatch to begin logging metrics from one or more EC2 instances
      #
      # @option options [Array] :instance_id ([])
      #
      def monitor_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = pathlist("InstanceId", options[:instance_id])
        return response_generator(:action => "MonitorInstances", :params => params)
      end


      # The UnmonitorInstances operation tells Cloudwatch to stop logging metrics from one or more EC2 instances
      #
      # @option options [Array] :instance_id ([])
      #
      def unmonitor_instances( options = {} )
        options = { :instance_id => [] }.merge(options)
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = pathlist("InstanceId", options[:instance_id])
        return response_generator(:action => "UnmonitorInstances", :params => params)
      end


      # Not yet implemented
      #
      # @todo Implement this method
      #
      def describe_reserved_instances( options = {} )
        raise "Not yet implemented"
      end


      # Not yet implemented
      #
      # @todo Implement this method
      #
      def describe_reserved_instances_offerings( options = {} )
        raise "Not yet implemented"
      end


      # Not yet implemented
      #
      # @todo Implement this method
      #
      def purchase_reserved_instances_offering( options = {} )
        raise "Not yet implemented"
      end



    end

    #
    # A set of methods for querying amazon's ec2 meta-data service.
    # Note : This can ONLY be run on an actual running EC2 instance.
    #
    # Example Class Method Usage :
    # instance_id = AWS::EC2::Instance.local_instance_id
    #
    class Instance

      EC2_META_URL_BASE = 'http://169.254.169.254/latest/meta-data/'

      #
      # Returns the current instance-id when called from a host within EC2.
      #
      def self.local_instance_id
        Net::HTTP.get URI.parse(EC2_META_URL_BASE + 'instance-id')
      end

      #
      # Returns a hash of all available instance meta data.
      #
      def self.local_instance_meta_data
        meta_data = {}

        Net::HTTP.get(URI.parse(EC2_META_URL_BASE)).split("\n").each do |meta_type|
          meta_data.merge!({meta_type => Net::HTTP.get(URI.parse(EC2_META_URL_BASE + meta_type)) })
        end

        return meta_data
      end

    end


  end
end

