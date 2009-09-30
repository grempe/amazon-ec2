module AWS
  module AutoScaling
    class Base < AWS::Base
      
      # Create a launch configuration
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
      def create_auto_scaling_group( options = {} )
        raise ArgumentError, "No :auto_scaling_group_name provided" if options[:auto_scaling_group_name].nil? || options[:auto_scaling_group_name].empty?
        raise ArgumentError, "No :availability_zones provided" if options[:availability_zones].nil? || options[:availability_zones].empty?
        raise ArgumentError, "No :load_balancer_names provided" if options[:load_balancer_names].nil? || options[:load_balancer_names].empty?
        raise ArgumentError, "No :launch_configuration_name provided" if options[:launch_configuration_name].nil? || options[:launch_configuration_name].empty?
        raise ArgumentError, "No :min_size provided" if options[:min_size].nil? || options[:min_size].empty?
        raise ArgumentError, "No :max_size provided" if options[:max_size].nil? || options[:max_size].empty?

        params = {}

        params.merge!(pathlist('AvailabilityZones.member', [options[:availability_zones]].flatten))
        params['LaunchConfigurationName'] = options[:launch_configuration_name]
        params['AutoScalingGroupName'] = options[:auto_scaling_group_name]
        params['MinSize'] = options[:min_size]
        params['MaxSize'] = options[:max_size]
        params['CoolDown'] = options[:cooldown] || 0
        
        return response_generator(:action => "CreateAutoScalingGroup", :params => params)
      end

      # This API deletes the specified LoadBalancer. On deletion, all of the
      # configured properties of the LoadBalancer will be deleted. If you
      # attempt to recreate the LoadBalancer, you need to reconfigure all the
      # settings. The DNS name associated with a deleted LoadBalancer is no
      # longer be usable. Once deleted, the name and associated DNS record of
      # the LoadBalancer no longer exist and traffic sent to any of its IP
      # addresses will no longer be delivered to your instances. You will not
      # get the same DNS name even if you create a new LoadBalancer with same
      # LoadBalancerName.
      #
      # @option options [String] :load_balancer_name the name of the load balancer
      #
      def delete_load_balancer( options = {} )
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?
        params = { 'LoadBalancerName' => options[:load_balancer_name] }
        return response_generator(:action => "DeleteLoadBalancer", :params => params)
      end

      # This API returns detailed configuration information for the specified
      # LoadBalancers, or if no LoadBalancers are specified, then the API
      # returns configuration information for all LoadBalancers created by the
      # caller. For more information, please see LoadBalancer.
      #
      # You must have created the specified input LoadBalancers in order to
      # retrieve this information. In other words, in order to successfully call
      # this API, you must provide the same account credentials as those that
      # were used to create the LoadBalancer.
      #
      # @option options [Array<String>] :load_balancer_names ([]) An Array of names of load balancers to describe.
      #
      def describe_load_balancers( options = {} )
        options = { :load_balancer_names => [] }.merge(options)
        params = pathlist("LoadBalancerName.member", options[:load_balancer_names])
        return response_generator(:action => "DescribeLoadBalancers", :params => params)
      end

      # This API adds new instances to the LoadBalancer.
      #
      # Once the instance is registered, it starts receiving traffic and
      # requests from the LoadBalancer. Any instance that is not in any of the
      # Availability Zones registered for the LoadBalancer will be moved to
      # the OutOfService state. It will move to the InService state when the
      # Availability Zone is added to the LoadBalancer.
      #
      # You must have been the one who created the LoadBalancer. In other
      # words, in order to successfully call this API, you must provide the
      # same account credentials as those that were used to create the
      # LoadBalancer.
      #
      # NOTE: Completion of this API does not guarantee that operation has
      # completed. Rather, it means that the request has been registered and
      # the changes will happen shortly.
      #
      # @option options [Array<String>] :instances An Array of instance names to add to the load balancer.
      # @option options [String] :load_balancer_name The name of the load balancer.
      #
      def register_instances_with_load_balancer( options = {} )
        raise ArgumentError, "No :instances provided" if options[:instances].nil? || options[:instances].empty?
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?
        params = {}
        params.merge!(pathlist('Instances.member', [options[:instances]].flatten))
        params['LoadBalancerName'] = options[:load_balancer_name]
        return response_generator(:action => "RegisterInstancesWithLoadBalancer", :params => params)
      end

      # This API deregisters instances from the LoadBalancer. Trying to
      # deregister an instance that is not registered with the LoadBalancer
      # does nothing.
      #
      # In order to successfully call this API, you must provide the same
      # account credentials as those that were used to create the
      # LoadBalancer.
      #
      # Once the instance is deregistered, it will stop receiving traffic from
      # the LoadBalancer.
      #
      # @option options [Array<String>] :instances An Array of instance names to remove from the load balancer.
      # @option options [String] :load_balancer_name The name of the load balancer.
      #
      def deregister_instances_from_load_balancer( options = {} )
        raise ArgumentError, "No :instances provided" if options[:instances].nil? || options[:instances].empty?
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?
        params = {}
        params.merge!(pathlist('Instances.member', [options[:instances]].flatten))
        params['LoadBalancerName'] = options[:load_balancer_name]
        return response_generator(:action => "DeregisterInstancesFromLoadBalancer", :params => params)
      end

      # This API enables you to define an application healthcheck for the
      # instances.
      #
      # Note: Completion of this API does not guarantee that operation has completed. Rather, it means that the request has been registered and the changes will happen shortly.
      #
      # @option options [Hash] :health_check A Hash with the keys (:timeout, :interval, :unhealthy_threshold, :healthy_threshold)
      # @option options [String] :load_balancer_name The name of the load balancer.
      #
      def configure_health_check( options = {} )
        raise ArgumentError, "No :health_check provided" if options[:health_check].nil? || options[:health_check].empty?
        raise ArgumentError, "No :health_check => :target provided" if options[:health_check][:target].nil? || options[:health_check][:target].empty?
        raise ArgumentError, "No :health_check => :timeout provided" if options[:health_check][:timeout].nil? || options[:health_check][:timeout].empty?
        raise ArgumentError, "No :health_check => :interval provided" if options[:health_check][:interval].nil? || options[:health_check][:interval].empty?
        raise ArgumentError, "No :health_check => :unhealthy_threshold provided" if options[:health_check][:unhealthy_threshold].nil? || options[:health_check][:unhealthy_threshold].empty?
        raise ArgumentError, "No :health_check => :healthy_threshold provided" if options[:health_check][:healthy_threshold].nil? || options[:health_check][:healthy_threshold].empty?
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?

        params = {}

        params['LoadBalancerName'] = options[:load_balancer_name]
        params['HealthCheck.Target'] = options[:health_check][:target]
        params['HealthCheck.Timeout'] = options[:health_check][:timeout]
        params['HealthCheck.Interval'] = options[:health_check][:interval]
        params['HealthCheck.UnhealthyThreshold'] = options[:health_check][:unhealthy_threshold]
        params['HealthCheck.HealthyThreshold'] = options[:health_check][:healthy_threshold]

        return response_generator(:action => "ConfigureHealthCheck", :params => params)
      end

      # Not yet implemented
      #
      # @todo Implement this method
      #
      def describe_instance_health( options = {} )
        raise "Not yet implemented"
      end

      # Not yet implemented
      #
      # @todo Implement this method
      #
      def disable_availability_zones_for_load_balancer( options = {} )
        raise "Not yet implemented"
      end

      # Not yet implemented
      #
      # @todo Implement this method
      #
      def enable_availability_zones_for_load_balancer( options = {} )
        raise "Not yet implemented"
      end

    end
  end
end