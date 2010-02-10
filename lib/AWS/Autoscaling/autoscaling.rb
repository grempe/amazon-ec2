module AWS
  module Autoscaling
    class Base < AWS::Base

      # Create a launch configuration
      # Creates a new Launch Configuration. Please note that the launch configuration name used must be unique, within the scope of your AWS account, and the maximum limit of launch configurations must not yet have been met, or else the call will fail.
      # Once created, the new launch configuration is available for immediate use.
      #
      # @option options [String] :launch_configuration_name (nil) the name of the launch configuration
      # @option options [String] :image_id (nil) the image id to use with this launch configuration
      # @option options [String] :instance_type (nil) the type of instance to launch
      # @option options [Array] :security_groups (nil) the names of security_groups to launch within
      # @option options [String] :key_name (nil) the name of the EC2 key pair
      # @option options [String] :user_data (nil) the user data available to the launched EC2 instances
      # @option options [String] :kernel_id (nil) the ID of the kernel associated with the EC2 ami
      # @option options [String] :ramdisk_id (nil) the name of the RAM disk associated with the EC2 ami
      # @option options [Array] :block_device_mappings (nil) specifies how block devices are exposed to the instance
      def create_launch_configuration( options = {})
        raise ArgumentError, "No :image_id provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        raise ArgumentError, "No :instance_type provided" if options[:instance_type].nil? || options[:instance_type].empty?

        params = {}
        params["ImageId"] = options[:image_id]
        params["KeyName"] = options[:key_name] if options[:key_name]
        params["LaunchConfigurationName"] = options[:launch_configuration_name]
        params.merge!(pathlist('SecurityGroups.member', [options[:security_groups]].flatten)) if options[:security_groups]
        params["UserData"] = options[:user_data] if options[:user_data]
        params["InstanceType"] = options[:instance_type] if options[:instance_type]
        params["KernelId"] = options[:kernel_id] if options[:kernel_id]
        params["RamdiskId"] = options[:ramdisk_id] if options[:ramdisk_id]
        params.merge!(pathlist('BlockDeviceMappings.member', [options[:block_device_mappings]].flatten)) if options[:block_device_mappings]

        return response_generator(:action => "CreateLaunchConfiguration", :params => params)
      end

      # Creates a new AutoScalingGroup with the specified name.
      # You must not have already used up your entire quota of AutoScalingGroups in order for this call to be successful. Once the creation request is completed, the AutoScalingGroup is ready to be used in other calls.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling group
      # @option options [Array] :availability_zones (nil) The availability_zones for the group
      # @option options [String] :launch_configuration_name (nil) the name of the launch_configuration group
      # @option options [String] :min_size (nil) minimum size of the group
      # @option options [String] :max_size (nil) the maximum size of the group
      # @option options [optional,Array] :load_balancer_names (nil) the names of the load balancers
      # @option options [optional,String] :cooldown (nil) the amount of time after a scaling activity complese before any further trigger-related scaling activities can start
      def create_autoscaling_group( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        raise ArgumentError, "No :availability_zones provided" if options[:availability_zones].nil? || options[:availability_zones].empty?
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        raise ArgumentError, "No :min_size provided" if options[:min_size].nil?
        raise ArgumentError, "No :max_size provided" if options[:max_size].nil?

        params = {}

        params.merge!(pathlist('AvailabilityZones.member', [options[:availability_zones]].flatten))
        params['LaunchConfigurationName'] = options[:launch_configuration_name]
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['MinSize'] = options[:min_size].to_s
        params['MaxSize'] = options[:max_size].to_s
        params.merge!(pathlist("LoadBalancerNames.member", [options[:load_balancer_names]].flatten)) if options.has_key?(:load_balancer_names)
        params['Cooldown'] = options[:cooldown] if options[:cooldown]

        return response_generator(:action => "CreateAutoScalingGroup", :params => params)
      end

      # Create or update scaling trigger
      # This call sets the parameters that governs when and how to scale an AutoScalingGroup.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling group
      # @option options [Array|Hash] :dimensions (nil) The dimensions associated with the metric used by the trigger to determine whether to activate
      #   This must be given as either an array or a hash
      #   When called as a hash, the values must look like: {:name => "name", :value => "value"}
      #   In the array format, the first value is assumed to be the name and the second is assumed to be the value
      # @option options [String] :measure_name (nil) the measure name associated with the metric used by the trigger
      # @option options [optional,String] :namespace (nil) namespace of the metric on which to trigger. Used to describe the monitoring metric.
      # @option options [String|Integer] :period (nil) the period associated with the metric in seconds
      # @option options [String] :statistic (nil) The particular statistic used by the trigger when fetching metric statistics to examine. Must be one of the following: Minimum, Maximum, Sum, Average
      # @option options [String] :trigger_name (nil) the name for this trigger
      # @option options [String] :unit (nil) the standard unit of measurement for a given measure
      # @option options [String|Integer] :lower_threshold (nil) the lower limit for the metric. If all datapoints in the last :breach_duration seconds fall below the lower threshold, the trigger will activate
      # @option options [String|Integer] :lower_breach_scale_increment (nil) the incremental amount to use when performing scaling activities when the lower threshold has been breached
      # @option options [String|Integer] :upper_threshold (nil) the upper limit for the metric. If all datapoints in the last :breach_duration seconds exceed the upper threshold, the trigger will activate
      # @option options [String|Integer] :upper_breach_scale_increment (nil) the incremental amount to use when performing scaling activities when the upper threshold has been breached
      def create_or_updated_scaling_trigger( options = {} )
        if options[:dimensions].nil? || options[:dimensions].empty?
          raise ArgumentError, "No :dimensions provided"
        end
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        raise ArgumentError, "No :measure_name provided" if options[:measure_name].nil? || options[:measure_name].empty?
        raise ArgumentError, "No :statistic provided" if options[:statistic].nil? || options[:statistic].empty?
        raise ArgumentError, "No :period provided" if options[:period].nil?
        raise ArgumentError, "No :trigger_name provided" if options[:trigger_name].nil? || options[:trigger_name].empty?
        raise ArgumentError, "No :lower_threshold provided" if options[:lower_threshold].nil?
        raise ArgumentError, "No :lower_breach_scale_increment provided" if options[:lower_breach_scale_increment].nil?
        raise ArgumentError, "No :upper_threshold provided" if options[:upper_threshold].nil?
        raise ArgumentError, "No :upper_breach_scale_increment provided" if options[:upper_breach_scale_increment].nil?
        raise ArgumentError, "No :breach_duration provided" if options[:breach_duration].nil?
        statistic_option_list = %w(minimum maximum average sum)
        unless statistic_option_list.include?(options[:statistic].downcase)

          raise ArgumentError, "The statistic option must be one of the following: #{statistic_option_list.join(", ")}"
        end

        params = {}
        params['Unit'] = options[:unit] if options[:unit]
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        case options[:dimensions]
        when Array
          params["Dimensions.member.1.Name"] = options[:dimensions][0]
          params["Dimensions.member.1.Value"] = options[:dimensions][1]
        when Hash
          params["Dimensions.member.1.Name"] = options[:dimensions][:name]
          params["Dimensions.member.1.Value"] = options[:dimensions][:value]
        else
          raise ArgumentError, "Dimensions must be either an array or a hash"
        end
        params['MeasureName'] = options[:measure_name]
        params['Namespace'] = options[:namespace] if options[:namespace]
        params['Statistic'] = options[:statistic]
        params['Period'] = options[:period].to_s
        params['TriggerName'] = options[:trigger_name]
        params['LowerThreshold'] = options[:lower_threshold].to_s
        params['LowerBreachScaleIncrement'] = options[:lower_breach_scale_increment].to_s
        params['UpperThreshold'] = options[:upper_threshold].to_s
        params['UpperBreachScaleIncrement'] = options[:upper_breach_scale_increment].to_s
        params['BreachDuration'] = options[:breach_duration].to_s

        return response_generator(:action => "CreateOrUpdateScalingTrigger", :params => params)
      end

      # Deletes all configuration for this AutoScalingGroup and also deletes the group.
      # In order to successfully call this API, no triggers (and therefore, Scaling Activity) can be currently in progress. Once this call successfully executes, no further triggers will begin and the AutoScalingGroup will not be available for use in other API calls. See key term Trigger.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling group
      def delete_autoscaling_group( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        params = { 'AutoScalingGroupName' => options[:autoscaling_group_name] }
        return response_generator(:action => "DeleteAutoScalingGroup", :params => params)
      end

      # Deletes the given Launch Configuration.
      # The launch configuration to be deleted must not be currently attached to any AutoScalingGroup. Once this call completes, the launch configuration is no longer available for use by any other API call.
      #
      # @option options [String] :launch_configuration_name (nil) the name of the launch_configuration
      def delete_launch_configuration( options = {} )
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        params = { 'LaunchConfigurationName' => options[:launch_configuration_name] }
        return response_generator(:action => "DeleteLaunchConfiguration", :params => params)
      end

      # Deletes the given trigger
      # If a trigger is currently in progress, it will continue to run until its activities are complete.
      #
      # @option options [String] :trigger_name (nil) the name of the trigger to delete
      def delete_trigger( options = {} )
        raise ArgumentError, "No :trigger_name provided" if options[:trigger_name].nil? || options[:trigger_name].empty?
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        params = { 'TriggerName' => options[:trigger_name], 'AutoScalingGroupName' => options[:autoscaling_group_name] }
        return response_generator(:action => "DeleteTrigger", :params => params)
      end

      # Describe autoscaling group
      # Returns a full description of the AutoScalingGroups from the given list. This includes all EC2 instances that are members of the group. If a list of names is not provided, then the full details of all AutoScalingGroups is returned. This style conforms to the EC2 DescribeInstances API behavior. See key term AutoScalingGroup.
      #
      # @option options [Array] :autoscaling_group_names (nil) the name of the autoscaling groups to describe
      def describe_autoscaling_groups( options = {} )
        options = { :autoscaling_group_names => [] }.merge(options)
        params = pathlist("AutoScalingGroupNames.member", options[:autoscaling_group_names])
        return response_generator(:action => "DescribeAutoScalingGroups", :params => params)
      end

      # Describe launch configurations
      # Returns a full description of the launch configurations given the specified names. If no names are specified, then the full details of all launch configurations are returned. See key term Launch Configuration.
      #
      # @option options [Array] :launch_configuration_names (nil) the name of the launch_configurations to describe
      def describe_launch_configurations( options = {} )
        options = { :launch_configuration_names => [] }.merge(options)
        params = pathlist("AutoScalingGroupNames.member", options[:launch_configuration_names])
        params['MaxRecords'] = options[:max_records].to_s if options.has_key?(:max_records)
        return response_generator(:action => "DescribeLaunchConfigurations", :params => params)
      end

      # Describe autoscaling activities
      # Returns the scaling activities specified for the given group. If the input list is empty, all the activities from the past six weeks will be returned. Activities will be sorted by completion time. Activities that have no completion time will be considered as using the most recent possible time. See key term Scaling Activity.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling_group_name
      # @option options [String] :max_records (nil) the maximum number of scaling activities to return
      # @option options [String] :launch_configuration_names (nil) activity_ids to return
      def describe_scaling_activities( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?

        params = {}
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['MaxRecords'] = options[:max_records] if options.has_key?(:max_records)
        params['ActivityIds'] = options[:activity_ids] if options.has_key?(:activity_ids)
        return response_generator(:action => "DescribeScalingActivities", :params => params)
      end

      # Describe triggers
      # Returns a full description of the trigger (see Trigger), in the specified AutoScalingGroup.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling_group_name
      def describe_triggers( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        params = {}
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]

        return response_generator(:action => "DescribeTriggers", :params => params)
      end

      # Set desired capacity
      # This API adjusts the desired size of the AutoScalingGroup by initiating scaling activities, as necessary. When adjusting the size of the group downward, it is not possible to define which EC2 instances will be terminated. This applies to any auto-scaling decisions that might result in the termination of instances.
      # To check the scaling status of the system, query the desired capacity using DescribeAutoScalingGroups and then query the actual capacity using DescribeAutoScalingGroups and looking at the instance lifecycle state in order to understand how close the system is to the desired capacity at any given time.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling_group_name
      # @option options [String] :desired_capacity (nil) the new capacity setting for the group
      def set_desired_capacity( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        raise ArgumentError, "No :desired_capacity provided" if options[:desired_capacity].nil? || options[:desired_capacity].empty?

        params = {}
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['DesiredCapacity'] = options[:desired_capacity].to_s

        return response_generator(:action => "SetDesiredCapacity", :params => params)
      end


      # Terminate instance in an autoscaling group
      # This call will terminate the specified Instance. Optionally, the desired group size can be adjusted. If set to true, the default, the AutoScalingGroup size will decrease by one. If the AutoScalingGroup is associated with a LoadBalancer, the system will deregister the instance before terminating it.
      # This call simply registers a termination request. The termination of the instance can not happen immediately.
      #
      # @option options [String] :instance_id (nil) the instance id to terminate
      # @option options [String] :decrement_desired_capacity (nil) specified whether terminating this instance should also decrement the size of the autoscaling group
      def terminate_instance_in_autoscaling_group( options = {} )
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?

        params = {}
        params['InstanceId'] = options[:instance_id]
        params['ShouldDecrementDesiredCapacity'] = options[:decrement_desired_capacity].to_s if options.has_key?(:decrement_desired_capacity)

        return response_generator(:action => "TerminateInstanceInAutoScalingGroup", :params => params)
      end

      # Creates a new AutoScalingGroup with the specified name.
      # Updates the configuration for the given AutoScalingGroup. If MaxSize is lower than the current size, then there will be an implicit call to SetDesiredCapacity to set the group to the new MaxSize. The same is true for MinSize there will also be an implicit call to SetDesiredCapacity. All optional parameters are left unchanged if not passed in the request.=
      # The new settings are registered upon the completion of this call. Any launch configuration settings will take effect on any triggers after this call returns. However, triggers that are currently in progress can not be affected. See key term Trigger.
      #
      # @option options [String] :autoscaling_group_name (nil) the name of the autoscaling group
      # @option options [Array] :availability_zones (nil) The availability_zones for the group
      # @option options [String] :launch_configuration_name (nil) the name of the launch_configuration group
      # @option options [String] :min_size (nil) minimum size of the group
      # @option options [String] :max_size (nil) the maximum size of the group
      # @option options [String] :cooldown (nil) the amount of time after a scaling activity complese before any further trigger-related scaling activities can start
      def update_autoscaling_group( options = {})
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?

        params = {}

        params.merge!(pathlist('AvailabilityZones.member', [options[:availability_zones]].flatten)) if options.has_key?(:availability_zones)
        params['LaunchConfigurationName'] = options[:launch_configuration_name] if options.has_key?(:launch_configuration_name)
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['MinSize'] = options[:min_size] if options.has_key?(:min_size)
        params['MaxSize'] = options[:max_size] if options.has_key?(:max_size)
        params['Cooldown'] = options[:cooldown]  if options.has_key?(:cooldown)

        return response_generator(:action => "UpdateAutoScalingGroup", :params => params)

      end

    end
  end
end

