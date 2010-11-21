module AWS
  module EC2

    class Base < AWS::Base

      # Creates a Spot Instance request. Spot Instances are instances that Amazon EC2 starts on your behalf
      # when the maximum price that you specify exceeds the current Spot Price. Amazon EC2 periodically sets
      # the Spot Price based on available Spot Instance capacity and current spot instance requests. For conceptual
      # information about Spot Instances, refer to the Amazon Elastic Compute Cloud Developer Guide or Amazon Elastic
      # Compute Cloud User Guide.
      #
      # @option options [String] :spot_price (nil) Specifies the maximum hourly price for any Spot Instance launched to fulfill the request.
      # @option options [optional,Integer] :instance_count (1) The maximum number of Spot Instances to launch.
      # @option options [optional,String] :type (nil) Specifies the Spot Instance type.
      # @option options [optional,Date] :valid_from (nil) Start date of the request. If this is a one-time request, the request becomes active at this date and time and remains active until all instances launch, the request expires, or the request is canceled. If the request is persistent, the request becomes active at this date and time and remains active until it expires or is canceled.
      # @option options [optional,Date] :valid_until (nil) End date of the request. If this is a one-time request, the request remains active until all instances launch, the request is canceled, or this date is reached. If the request is persistent, it remains active until it is canceled or this date and time is reached.
      # @option options [optional,String] :launch_group (nil) Specifies the instance launch group. Launch groups are Spot Instances that launch together and terminate together.
      # @option options [optional,String] :availability_zone_group ("") Specifies the Availability Zone group. If you specify the same Availability Zone group for all Spot Instance requests, all Spot Instances are launched in the same Availability Zone.
      # @option options [optional,String] :image_id (nil) The AMI ID.
      # @option options [optional,String] :key_name (nil) The name of the key pair.
      # @option options [optional,Array of Strings or String] :security_group (nil) Name of the security group(s).
      # @option options [optional,String] :user_data (nil) MIME, Base64-encoded user data.
      # @option options [optional,String] :instance_type ("m1.small") Specifies the instance type.
      # @option options [optional,String] :kernel_id (nil) The ID of the kernel to select.
      # @option options [optional,String] :ramdisk_id (nil) The ID of the RAM disk to select. Some kernels require additional drivers at launch. Check the kernel requirements for information on whether you need to specify a RAM disk and search for the kernel ID.
      # @option options [optional,String] :subnet_id (nil) Specifies the Amazon VPC subnet ID within which to launch the instance(s) for Amazon Virtual Private Cloud.
      # @option options [optional,String] :availability_zone (nil) Specifies the placement constraints (Availability Zones) for launching the instances.
      # @option options [optional, Array] :block_device_mapping ([]) An array of Hashes representing the elements of the block device mapping.  e.g. [{:device_name => '/dev/sdh', :virtual_name => '', :ebs_snapshot_id => '', :ebs_volume_size => '', :ebs_delete_on_termination => ''},{},...]
      # @option options [optional, Boolean] :monitoring_enabled (false) Enables monitoring for the instance.
      # @option options [optional, Boolean] :base64_encoded (false)
      #
      def request_spot_instances( options = {} )
        options = { :instance_count => 1,
                    :instance_type => 'm1.small',
                    :base64_encoded => false }.merge(options)

        raise ArgumentError, ":addressing_type has been deprecated." if options[:addressing_type]
        raise ArgumentError, ":spot_price must be provided" if options[:spot_price].nil? || options[:spot_price].empty?
        raise ArgumentError, ":base64_encoded must be 'true' or 'false'" unless [true, false].include?(options[:base64_encoded])
        raise ArgumentError, ":instance_type must specify a valid instance type" unless options[:instance_type].nil? || ["t1.micro", "m1.small", "m1.large", "m1.xlarge", "m2.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge", "cc1.4xlarge"].include?(options[:instance_type])

        user_data = extract_user_data(options)

        params = {}

        if options[:security_group]
          params.merge!(pathlist("LaunchSpecification.SecurityGroup", options[:security_group]))
        end

        if options[:block_device_mapping]
          params.merge!(pathhashlist('LaunchSpecification.BlockDeviceMapping', options[:block_device_mapping].flatten, {:device_name => 'DeviceName', :virtual_name => 'VirtualName', :ebs_snapshot_id => 'Ebs.SnapshotId', :ebs_volume_size => 'Ebs.VolumeSize', :ebs_delete_on_termination => 'Ebs.DeleteOnTermination' }))
        end

        params["SpotPrice"]                                             = options[:spot_price]
        params["InstanceCount"]                                         = options[:instance_count].to_s
        params["Type"]                                                  = options[:type] unless options[:type].nil?
        params["ValidFrom"]                                             = options[:valid_from].to_s unless options[:valid_from].nil?
        params["ValidUntil"]                                            = options[:valid_until].to_s unless options[:valid_until].nil?
        params["LaunchGroup"]                                           = options[:launch_group] unless options[:launch_group].nil?
        params["AvailabilityZoneGroup"]                                 = options[:availability_zone_group] unless options[:availability_zone_group].nil?
        params["LaunchSpecification.ImageId"]                           = options[:image_id] unless options[:image_id].nil?
        params["LaunchSpecification.KeyName"]                           = options[:key_name] unless options[:key_name].nil?
        params["LaunchSpecification.UserData"]                          = user_data unless user_data.nil?
        params["LaunchSpecification.InstanceType"]                      = options[:instance_type] unless options[:instance_type].nil?
        params["LaunchSpecification.KernelId"]                          = options[:kernel_id] unless options[:kernel_id].nil?
        params["LaunchSpecification.RamdiskId"]                         = options[:ramdisk_id] unless options[:ramdisk_id].nil?
        params["LaunchSpecification.SubnetId"]                          = options[:subnet_id] unless options[:subnet_id].nil?
        params["LaunchSpecification.Placement.AvailabilityZone"]        = options[:availability_zone] unless options[:availability_zone].nil?
        params["LaunchSpecification.Monitoring.Enabled"]                = options[:monitoring_enabled].to_s unless options[:monitoring_enabled].nil?

        return response_generator(:action => "RequestSpotInstances", :params => params)
      end

      # Describes Spot Instance requests. Spot Instances are instances that Amazon EC2 starts on your behalf when the
      # maximum price that you specify exceeds the current Spot Price. Amazon EC2 periodically sets the Spot Price
      # based on available Spot Instance capacity and current spot instance requests. For conceptual information about
      # Spot Instances, refer to the Amazon Elastic Compute Cloud Developer Guide or Amazon Elastic Compute Cloud User Guide.
      #
      # @option options [Array] :spot_instance_request_id ([])
      #
      def describe_spot_instance_requests( options = {} )
        options = { :spot_instance_request_id => []}.merge(options)
        params = pathlist( "SpotInstanceRequestId", options[:spot_instance_request_id] )

        return response_generator(:action => "DescribeSpotInstanceRequests", :params => params)
      end

      # Cancels one or more Spot Instance requests. Spot Instances are instances that Amazon EC2 starts on your behalf
      # when the maximum price that you specify exceeds the current Spot Price. Amazon EC2 periodically sets the Spot
      # Price based on available Spot Instance capacity and current spot instance requests. For conceptual information
      # about Spot Instances, refer to the Amazon Elastic Compute Cloud Developer Guide or Amazon Elastic Compute Cloud
      # User Guide.
      #
      # NB: Canceling a Spot Instance request does not terminate running Spot Instances associated with the request.
      #
      # @option options [Array] :spot_instance_request_id ([])
      #
      def cancel_spot_instance_requests( options = {} )
        options = { :spot_instance_request_id => []}.merge(options)
        params = pathlist( "SpotInstanceRequestId", options[:spot_instance_request_id] )

        return response_generator(:action => "CancelSpotInstanceRequests", :params => params)
      end

    end
  end
end

