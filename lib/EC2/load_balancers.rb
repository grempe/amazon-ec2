module EC2
  class Base
    # Amazon Developer Guide Docs:
    #
    # This API creates a new LoadBalancer. Once the call has completed successfully, a new LoadBalancer will be created, but it will not be usable until at least one instance has been registered.
    # When the LoadBalancer creation is completed, you can check whether it is usable by using the DescribeInstanceHealth API. The LoadBalancer is usable as soon as any registered instance is InService.
    #
    # Required Arguments:
    #
    #  :availability_zone => String (default : '')
    #
    #Optional Arguments:
    #
    # :size => String (default : '')
    # :snapshot_id => String (default : '')
    #

    def create_load_balancer( options = {} )
      raise ArgumentError, "No :availability_zones provided" if options[:availability_zones].nil? || options[:availability_zones].empty?
      raise ArgumentError, "No :listeners provided" if options[:listeners].nil? || options[:listeners].empty?
      raise ArgumentError, "No :load_balancer_name provided" if options[:load_balancer_name].nil? || options[:load_balancer_name].empty?

      params = {}
      
      [options[:availability_zones]].flatten.length.times do |i|
        params["AvailabilityZones.member.#{i+1}"] = options[:availability_zones][i]
      end
      
      [options[:listeners]].flatten.length.times do |i|
        listener = options[:listeners][i]
        params["Listeners.member.#{i+1}.Protocol"] = listener[:protocol]
        params["Listeners.member.#{i+1}.LoadBalancerPort"] = listener[:load_balancer_port]
        params["Listeners.member.#{i+1}.InstancePort"] = listener[:instance_port]
      end

      params['LoadBalancerName'] = options[:load_balancer_name]

      return response_generator(:action => "CreateLoadBalancer", :params => params)
    end
      
  end
end