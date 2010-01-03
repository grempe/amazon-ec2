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
      # @option options [optional,String] :instance_type (nil) Specifies the instance type.
      # @option options [optional,String] :kernel_id (nil) The ID of the kernel to select.
      # @option options [optional,String] :ramdisk_id (nil) The ID of the RAM disk to select. Some kernels require additional drivers at launch. Check the kernel requirements for information on whether you need to specify a RAM disk and search for the kernel ID.
      # @option options [optional,String] :subnet_id (nil) Specifies the Amazon VPC subnet ID within which to launch the instance(s) for Amazon Virtual Private Cloud.
      # @option options [optional,String] :availability_zone (nil) Specifies the placement constraints (Availability Zones) for launching the instances.
      # @option options [optional, Array] :block_device_mapping ([]) An array of Hashes representing the elements of the block device mapping.  e.g. [{:device_name => '/dev/sdh', :virtual_name => '', :ebs_snapshot_id => '', :ebs_volume_size => '', :ebs_delete_on_termination => ''},{},...]
      # @option options [optional, Boolean] :monitoring_enabled (false) Enables monitoring for the instance.
      def create_spot_instances_request( options = {} )
        options = { :instance_count => 1,
                    :base64_encoded => false }.merge(options)

        raise ArgumentError, ":addressing_type has been deprecated." if options[:addressing_type]
        raise ArgumentError, ":spot_price must be provided" if options[:spot_price].nil? || options[:spot_price].empty?

        user_data = extract_user_data(options)

        params = {}

        if options[:security_group]
          params.merge!(pathlist("SecurityGroup", options[:security_group]))
        end

        if options[:block_device_mapping]
          params.merge!(pathhashlist('BlockDeviceMapping', options[:block_device_mapping].flatten, {:device_name => 'DeviceName', :virtual_name => 'VirtualName', :ebs_snapshot_id => 'Ebs.SnapshotId', :ebs_volume_size => 'Ebs.VolumeSize', :ebs_delete_on_termination => 'Ebs.DeleteOnTermination' }))
        end

        params["SpotPrice"]                         = options[:spot_price]
        params["InstanceCount"]                     = options[:instance_count].to_s
        params["Type"]                              = options[:type] unless options[:type].nil?
        params["ValidFrom"]                         = options[:valid_from].to_s unless options[:valid_from].nil?
        params["ValidUntil"]                        = options[:valid_until].to_s unless options[:valid_until].nil?
        params["LaunchGroup"]                       = options[:launch_group] unless options[:launch_group].nil?
        params["AvailabilityZoneGroup"]             = options[:availability_zone_group] unless options[:availability_zone_group].nil?
        params["ImageId"]                           = options[:image_id] unless options[:image_id].nil?
        params["KeyName"]                           = options[:key_name] unless options[:key_name].nil?
        params["UserData"]                          = user_data unless user_data.nil?
        params["AddressingType"]                    = options[:address_type] unless options[:address_type].nil?
        params["InstanceType"]                      = options[:instance_type] unless options[:instance_type].nil?
        params["KernelId"]                          = options[:kernel_id] unless options[:kernel_id].nil?
        params["RamdiskId"]                         = options[:ramdisk_id] unless options[:ramdisk_id].nil?
        params["SubnetId"]                          = options[:subnet_id] unless options[:subnet_id].nil?
        params["Placement.AvailabilityZone"]        = options[:availability_zone] unless options[:availability_zone].nil?
        params["Monitory.Enabled"]                  = options[:monitoring_enabled].to_s unless options[:monitoring_enabled].nil?
        
        return response_generator(:action => "RequestSpotInstances", :params => params)
      end

=begin
      # Creates an AMI that uses an Amazon EBS root device from a "running" or "stopped" instance.
      #
      # AMIs that use an Amazon EBS root device boot faster than AMIs that use instance stores.
      # They can be up to 1 TiB in size, use storage that persists on instance failure, and can be
      # stopped and started.
      #
      # @option options [String] :instance_id ("") The ID of the instance.
      # @option options [String] :name ("") The name of the AMI that was provided during image creation. Constraints 3-128 alphanumeric characters, parenthesis (()), commas (,), slashes (/), dashes (-), or underscores(_)
      # @option options [optional,String] :description ("") The description of the AMI that was provided during image creation.
      # @option options [optional,Boolean] :no_reboot (false) By default this property is set to false, which means Amazon EC2 attempts to cleanly shut down the instance before image creation and reboots the instance afterwards. When set to true, Amazon EC2 does not shut down the instance before creating the image. When this option is used, file system integrity on the created image cannot be guaranteed.
      #
      def create_image( options = {} )
        options = { :instance_id => "", :name => "" }.merge(options)
        raise ArgumentError, "No :instance_id provided" if options.does_not_have? :instance_id
        raise ArgumentError, "No :name provided" if options.does_not_have? :name
        raise ArgumentError, "Invalid string length for :name provided" if options[:name] && options[:name].size < 3 || options[:name].size > 128
        raise ArgumentError, "Invalid string length for :description provided (too long)" if options[:description] && options[:description].size > 255
        raise ArgumentError, ":no_reboot option must be a Boolean" unless options[:no_reboot].nil? || [true, false].include?(options[:no_reboot])
        params = {}
        params["InstanceId"] = options[:instance_id].to_s
        params["Name"] = options[:name].to_s
        params["Description"] = options[:description].to_s
        params["NoReboot"] = options[:no_reboot].to_s
        return response_generator(:action => "CreateImage", :params => params)
      end


      # The DeregisterImage operation deregisters an AMI. Once deregistered, instances of the AMI may no
      # longer be launched.
      #
      # @option options [String] :image_id ("")
      #
      def deregister_image( options = {} )
        options = { :image_id => "" }.merge(options)
        raise ArgumentError, "No :image_id provided" if options[:image_id].nil? || options[:image_id].empty?
        params = { "ImageId" => options[:image_id] }
        return response_generator(:action => "DeregisterImage", :params => params)
      end


      # The RegisterImage operation registers an AMI with Amazon EC2. Images must be registered before
      # they can be launched.  Each AMI is associated with an unique ID which is provided by the EC2
      # service via the Registerimage operation. As part of the registration process, Amazon EC2 will
      # retrieve the specified image manifest from Amazon S3 and verify that the image is owned by the
      # user requesting image registration.  The image manifest is retrieved once and stored within the
      # Amazon EC2 network. Any modifications to an image in Amazon S3 invalidate this registration.
      # If you do have to make changes and upload a new image deregister the previous image and register
      # the new image.
      #
      # @option options [String] :image_location ("")
      #
      def register_image( options = {} )
        options = {:image_location => ""}.merge(options)
        raise ArgumentError, "No :image_location provided" if options[:image_location].nil? || options[:image_location].empty?
        params = { "ImageLocation" => options[:image_location] }
        return response_generator(:action => "RegisterImage", :params => params)
      end


      # The DescribeImages operation returns information about AMIs available for use by the user. This
      # includes both public AMIs (those available for any user to launch) and private AMIs (those owned by
      # the user making the request and those owned by other users that the user making the request has explicit
      # launch permissions for).
      #
      # The list of AMIs returned can be modified via optional lists of AMI IDs, owners or users with launch
      # permissions. If all three optional lists are empty all AMIs the user has launch permissions for are
      # returned. Launch permissions fall into three categories:
      #
      # Launch Permission Description
      #
      # public - The all group has launch permissions for the AMI. All users have launch permissions for these AMIs.
      # explicit - The owner of the AMIs has granted a specific user launch permissions for the AMI.
      # implicit - A user has implicit launch permissions for all AMIs he or she owns.
      #
      # If one or more of the lists are specified the result set is the intersection of AMIs matching the criteria of
      # the individual lists.
      #
      # Providing the list of AMI IDs requests information for those AMIs only. If no AMI IDs are provided,
      # information of all relevant AMIs will be returned. If an AMI is specified that does not exist a fault is
      # returned. If an AMI is specified that exists but the user making the request does not have launch
      # permissions for, then that AMI will not be included in the returned results.
      #
      # Providing the list of owners requests information for AMIs owned by the specified owners only. Only
      # AMIs the user has launch permissions for are returned. The items of the list may be account ids for
      # AMIs owned by users with those account ids, amazon for AMIs owned by Amazon or self for AMIs
      # owned by the user making the request.
      #
      # The executable list may be provided to request information for AMIs that only the specified users have
      # launch permissions for. The items of the list may be account ids for AMIs owned by the user making the
      # request that the users with the specified account ids have explicit launch permissions for, self for AMIs
      # the user making the request has explicit launch permissions for or all for public AMIs.
      #
      # Deregistered images will be included in the returned results for an unspecified interval subsequent to
      # deregistration.
      #
      # @option options [Array] :image_id ([])
      # @option options [Array] :owner_id ([])
      # @option options [Array] :executable_by ([])
      #
      def describe_images( options = {} )
        options = { :image_id => [], :owner_id => [], :executable_by => [] }.merge(options)
        params = pathlist( "ImageId", options[:image_id] )
        params.merge!(pathlist( "Owner", options[:owner_id] ))
        params.merge!(pathlist( "ExecutableBy", options[:executable_by] ))
        return response_generator(:action => "DescribeImages", :params => params)
      end
=end

    end
  end
end

