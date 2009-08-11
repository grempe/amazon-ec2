module AWS
  module ELB
    class Base < AWS::Base
      # Amazon Developer Guide Docs:
      #
      # This API creates a new LoadBalancer. Once the call has completed
      # successfully, a new LoadBalancer will be created, but it will not be
      # usable until at least one instance has been registered. When the
      # LoadBalancer creation is completed, you can check whether it is usable
      # by using the DescribeInstanceHealth API. The LoadBalancer is usable as
      # soon as any registered instance is InService.
      #
      # Required Arguments:
      #
      #  :load_balancer_name => String
      #  :availability_zones => Array
      #  :listeners => Array of Hashes (:protocol, :load_balancer_port, :instance_port)
      #  :availability_zones => Array of Strings
      #
      def create_load_balancer( options = {} )
        raise ArgumentError, "No :availability_zones provided" if options[:availability_zones].nil? || options[:availability_zones].empty?
        raise ArgumentError, "No :listeners provided" if options[:listeners].nil? || options[:listeners].empty?
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?

        params = {}

        params.merge!(pathlist('AvailabilityZones.member', [options[:availability_zones]].flatten))
        params.merge!(pathhashlist('Listeners.member', [options[:listeners]].flatten, {
          :protocol => 'Protocol',
          :load_balancer_port => 'LoadBalancerPort',
          :instance_port => 'InstancePort'
        }))
        params['LoadBalancerName'] = options[:load_balancer_name]

        return response_generator(:action => "CreateLoadBalancer", :params => params)
      end

      # Amazon Developer Guide Docs:
      #
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
      # Required Arguments:
      #
      #  :load_balancer_name => String
      #
      def delete_load_balancer( options = {} )
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?

        params = { 'LoadBalancerName' => options[:load_balancer_name] }

        return response_generator(:action => "DeleteLoadBalancer", :params => params)
      end

      # Amazon Developer Guide Docs:
      #
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
      # Optional Arguments:
      #
      #  :load_balancer_names => String
      #
      def describe_load_balancers( options = {} )
        options = { :load_balancer_names => [] }.merge(options)

        params = pathlist("LoadBalancerName.member", options[:load_balancer_names])

        return response_generator(:action => "DescribeLoadBalancers", :params => params)
      end

      # Amazon Developer Guide Docs:
      #
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
      # Required Arguments:
      #
      #  :instances => Array of Strings
      #  :load_balancer_name => String
      #
      def register_instances_with_load_balancer( options = {} )
        raise ArgumentError, "No :instances provided" if options[:instances].nil? || options[:instances].empty?
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?

        params = {}

        params.merge!(pathlist('Instances.member', [options[:instances]].flatten))
        params['LoadBalancerName'] = options[:load_balancer_name]

        return response_generator(:action => "RegisterInstancesWithLoadBalancer", :params => params)
      end

      # Amazon Developer Guide Docs:
      #
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
      # Required Arguments:
      #
      #  :instances => Array of Strings
      #  :load_balancer_name => String
      #
      def deregister_instances_from_load_balancer( options = {} )
        raise ArgumentError, "No :instances provided" if options[:instances].nil? || options[:instances].empty?
        raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?

        params = {}

        params.merge!(pathlist('Instances.member', [options[:instances]].flatten))
        params['LoadBalancerName'] = options[:load_balancer_name]

        return response_generator(:action => "DeregisterInstancesFromLoadBalancer", :params => params)
      end

      # Amazon Developer Guide Docs:
      #
      # This API enables you to define an application healthcheck for the
      # instances.
      #
      # Note: Completion of this API does not guarantee that operation has completed. Rather, it means that the request has been registered and the changes will happen shortly.
      #
      # Required Arguments
      #
      #  :health_check => Hash (:timeout, :interval, :unhealthy_threshold, :healthy_threshold)
      #  :load_balancer_name => String
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

      def describe_intance_health( options = {} )
        raise "Not yet implemented"
      end

      def disable_availability_zones_for_load_balancer( options = {} )
        raise "Not yet implemented"
      end

      def enable_availability_zones_for_load_balancer( options = {} )
        raise "Not yet implemented"
      end
    end
  end
end