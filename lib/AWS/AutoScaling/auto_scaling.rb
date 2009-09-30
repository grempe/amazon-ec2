module AWS
  module AutoScaling
    class Base < AWS::Base
      
      # Create a launch configuration
      # TODO: Docs
      def create_launch_configuration( options = {})
        raise ArgumentError, "No :image_id provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        raise ArgumentError, "No :instance_type provided" if options[:instance_type].nil? || options[:instance_type].empty?
        
        params = {}
        params["ImageId"] = options[:image_id]
        params["KeyName"] = options[:key_name] if options[:key_name]
        params["LaunchConfigurationName"] = options[:launch_configuration_name]
        params.merge!(pathlist('SecurityGroups.member', [options[:security_groups]].flatten))
        params["UserData"] = options[:user_data] if options[:user_data]
        params["InstanceType"] = options[:instance_type] if options[:instance_type]
        params["KernelId"] = options[:kernel_id] if options[:kernel_id]
        params["RamdiskId"] = options[:ramdisk_id] if options[:ramdisk_id]
        params.merge!(pathlist('BlockDeviceMappings.member', [options[:block_device_mappings]].flatten)) if options[:block_device_mappings]
        
        return response_generator(:action => "CreateLaunchConfiguration", :params => params)
      end
      
      # Create an autoscaling group
      # TODO: Add docs
      def create_autoscaling_group( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        raise ArgumentError, "No :availability_zones provided" if options[:availability_zones].nil? || options[:availability_zones].empty?
        raise ArgumentError, "No :load_balancer_names provided" if options[:load_balancer_names].nil? || options[:load_balancer_names].empty?
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        raise ArgumentError, "No :min_size provided" if options[:min_size].nil? || options[:min_size].empty?
        raise ArgumentError, "No :max_size provided" if options[:max_size].nil? || options[:max_size].empty?

        params = {}

        params.merge!(pathlist('AvailabilityZones.member', [options[:availability_zones]].flatten))
        params['LaunchConfigurationName'] = options[:launch_configuration_name]
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['MinSize'] = options[:min_size]
        params['MaxSize'] = options[:max_size]
        params['CoolDown'] = options[:cooldown] || 0
        
        return response_generator(:action => "CreateAutoScalingGroup", :params => params)
      end
      
      # Create or update scaling trigger
      def create_or_updated_scaling_trigger( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        raise ArgumentError, "No :dimensions provided" if options[:dimensions].nil? || options[:dimensions].empty?
        raise ArgumentError, "No :measure_name provided" if options[:measure_name].nil? || options[:measure_name].empty?
        raise ArgumentError, "No :statistic provided" if options[:statistic].nil? || options[:statistic].empty?
        raise ArgumentError, "No :period provided" if options[:period].nil? || options[:period].empty?
        raise ArgumentError, "No :trigger_name provided" if options[:trigger_name].nil? || options[:trigger_name].empty?
        raise ArgumentError, "No :lower_threshold provided" if options[:lower_threshold].nil? || options[:lower_threshold].empty?
        raise ArgumentError, "No :lower_breach_scale_increment provided" if options[:lower_breach_scale_increment].nil? || options[:lower_breach_scale_increment].empty?
        raise ArgumentError, "No :upper_threshold provided" if options[:upper_threshold].nil? || options[:upper_threshold].empty?
        raise ArgumentError, "No :upper_breach_scale_increment provided" if options[:upper_breach_scale_increment].nil? || options[:upper_breach_scale_increment].empty?
        raise ArgumentError, "No :breach_duration provided" if options[:breach_duration].nil? || options[:breach_duration].empty?
        
        statistic_option_list = %w(Minimum Maximum Average Sum)
        unless statistic_option_list.include?(options[:statistic])
          raise ArgumentError, "The statistic option must be one of the following: #{statistic_option_list.join(", ")}"
        end
        
        params = {}
        params['Unit'] = options[:unit] || "Seconds"
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params.merge!(pathlist('Dimensions.member', [options[:dimensions]].flatten))
        params['MeasureName'] = options[:measure_name]
        params['Statistic'] = options[:statistic]
        params['Period'] = options[:period]
        params['TriggerName'] = options[:trigger_name]
        params['LowerThreshold'] = options[:lower_threshold]
        params['LowerBreachScaleIncrement'] = options[:lower_breach_scale_increment]
        params['UpperThreshold'] = options[:upper_threshold]
        params['UpperBreachScaleIncrement'] = options[:upper_breach_scale_increment]
        params['BreachDuration'] = options[:breach_duration]
        
        return response_generator(:action => "CreateOrUpdateScalingTrigger", :params => params)
      end
      
      # Delete autoscaling group
      def delete_autoscaling_group( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        params = { 'AutoScalingGroupName' => options[:autoscaling_group_name] }
        return response_generator(:action => "DeleteAutoScalingGroup", :params => params)
      end
      
      # Delete launch configuration
      def delete_launch_configuration( options = {} )
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        params = { 'LaunchConfigurationName' => options[:launch_configuration_name] }
        return response_generator(:action => "DeleteLaunchConfiguration", :params => params)
      end
      
      # Delete launch trigger
      def delete_trigger( options = {} )
        raise ArgumentError, "No :trigger_name provided" if options[:trigger_name].nil? || options[:trigger_name].empty?
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        params = { 'TriggerName' => options[:trigger_name], 'AutoScalingGroupName' => options[:autoscaling_group_name] }
        return response_generator(:action => "DeleteTrigger", :params => params)
      end

      # Describe autoscaling group
      def describe_autoscaling_groups( options = {} )
        options = { :autoscaling_group_names => [] }.merge(options)
        params = pathlist("AutoScalingGroupNames.member", options[:autoscaling_group_names])
        return response_generator(:action => "DescribeAutoScalingGroups", :params => params)
      end
      
      # Describe launch configurations
      def describe_launch_configurations( options = {} )
        options = { :launch_configuration_names => [] }.merge(options)
        params = pathlist("AutoScalingGroupNames.member", options[:launch_configuration_names])
        params['MaxRecords'] = options[:max_records] || 100
        return response_generator(:action => "DescribeLaunchConfigurations", :params => params)
      end
      
      # Describe autoscaling activities
      def describe_scaling_activities( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        
        params = {}
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['MaxRecords'] = options[:max_records] || 100
        params['MaxRecords'] = options[:activity_ids] if options.has_key?(:activity_ids)
        return response_generator(:action => "DescribeScalingActivities", :params => params)
      end
      
      # Describe triggers
      def describe_triggers( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        params = {}
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        
        return response_generator(:action => "DescribeTriggers", :params => params)
      end
      
      # Set desired capacity
      def set_desired_capacity( options = {} )
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?
        raise ArgumentError, "No :desired_capacity provided" if options[:desired_capacity].nil? || options[:desired_capacity].empty?
        
        params = {}
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['DesiredCapacity'] = options[:desired_capacity]
        
        return response_generator(:action => "SetDesiredCapacity", :params => params)
      end


      # Terminate instance in an autoscaling group
      def terminate_instance_in_autoscaling_group( options = {} )
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        
        params = {}
        params['InstanceId'] = options[:instance_id]
        params['ShouldDecrementDesiredCapacity'] = options[:decrement_desired_capacity] || true
        
        return response_generator(:action => "TerminateInstanceInAutoScalingGroup", :params => params)
      end
      
      def update_autoscaling_group( options = {})
        raise ArgumentError, "No :autoscaling_group_name provided" if options[:autoscaling_group_name].nil? || options[:autoscaling_group_name].empty?

        params = {}

        params.merge!(pathlist('AvailabilityZones.member', [options[:availability_zones]].flatten)) if options.has_key?(:availability_zones)
        params['LaunchConfigurationName'] = options[:launch_configuration_name] if options.has_key?(:launch_configuration_name)
        params['AutoScalingGroupName'] = options[:autoscaling_group_name]
        params['MinSize'] = options[:min_size] if options.has_key?(:min_size)
        params['MaxSize'] = options[:max_size] if options.has_key?(:max_size)
        params['CoolDown'] = options[:cooldown]  if options.has_key?(:cooldown)
        
        return response_generator(:action => "UpdateAutoScalingGroup", :params => params)
        
      end

    end
  end
end