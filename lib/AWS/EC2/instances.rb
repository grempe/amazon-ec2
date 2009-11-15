module AWS
  module EC2

    class Base < AWS::Base

      # The RunInstances operation launches a specified number of instances.
      #
      # Note : The Query version of RunInstances only allows instances of a single AMI to be launched in
      # one call. This is different from the SOAP API call of the same name but similar to the
      # ec2-run-instances command line tool.
      #
      # If Amazon EC2 cannot launch the minimum number AMIs you request, no instances launch. If there
      # is insufficient capacity to launch the maximum number of AMIs you request, Amazon EC2 launches
      # as many as possible to satisfy the requested maximum values.
      #
      # Every instance is launched in a security group. If you do not specify a security group at
      # launch, the instances start in the default security group.
      #
      # An optional instance type can be specified.  Currently supported types are 'm1.small', 'm1.large',
      # 'm1.xlarge' and the high CPU types 'c1.medium' and 'c1.xlarge'.  'm1.small' is the default
      # if no instance_type is specified.
      #
      # You can provide an optional key pair ID for each image in the launch request. All instances
      # that are created from images that use this key pair will have access to the associated public
      # key at boot. You can use this key to provide secure access to an instance of an image on a
      # per-instance basis. Amazon EC2  public images use this feature to provide secure access
      # without passwords.
      #
      # Important!  Launching public images without a key pair ID will leave them inaccessible.
      #
      # The public key material is made available to the instance at boot time by placing it in a file named
      # openssh_id.pub on a logical device that is exposed to the instance as /dev/sda2 (the ephemeral
      # store). The format of this file is suitable for use as an entry within ~/.ssh/authorized_keys (the
      # OpenSSH format). This can be done at boot time (as part of rclocal, for example) allowing for secure
      # password-less access.
      #
      # Optional user data can be provided in the launch request. All instances comprising the launch
      # request have access to this data (see Instance Metadata for details).
      #
      # If any of the AMIs have product codes attached for which the user has not subscribed,
      # the RunInstances call will fail.
      #
      # @option options [String] :image_id ("")
      # @option options [Integer] :min_count (1)
      # @option options [Integer] :max_count (1)
      # @option options [optional, String] :key_name (nil)
      # @option options [optional, Array] :group_id ([])
      # @option options [optional, String] :user_data (nil)
      # @option options [optional, String] :addressing_type ("public")
      # @option options [optional, String] :instance_type ("m1.small")
      # @option options [optional, String] :kernel_id (nil)
      # @option options [optional, String] :availability_zone (nil)
      # @option options [optional, Boolean] :base64_encoded (false)
      #
      def run_instances( options = {} )

        options = { :image_id => "",
                    :min_count => 1,
                    :max_count => 1,
                    :key_name => nil,
                    :group_id => [],
                    :user_data => nil,
                    :addressing_type => "public",
                    :instance_type => "m1.small",
                    :kernel_id => nil,
                    :availability_zone => nil,
                    :base64_encoded => false }.merge(options)

        # Do some validation on the arguments provided
        raise ArgumentError, ":image_id must be provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, ":min_count is not valid" unless options[:min_count].to_i > 0
        raise ArgumentError, ":max_count is not valid" unless options[:max_count].to_i > 0
        raise ArgumentError, ":addressing_type must be 'direct' or 'public'" unless ["public", "direct"].include?(options[:addressing_type])
        raise ArgumentError, ":instance_type must specify a valid instance size" unless ["m1.small", "m1.large", "m1.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge"].include?(options[:instance_type])
        raise ArgumentError, ":base64_encoded must be 'true' or 'false'" unless [true, false].include?(options[:base64_encoded])

        user_data = extract_user_data(options)

        params = {
          "ImageId"  => options[:image_id],
          "MinCount" => options[:min_count].to_s,
          "MaxCount" => options[:max_count].to_s,
        }.merge(pathlist("SecurityGroup", options[:group_id]))

        params["KeyName"] = options[:key_name] unless options[:key_name].nil?
        params["UserData"] = user_data unless user_data.nil?
        params["AddressingType"] = options[:addressing_type]
        params["InstanceType"] = options[:instance_type]
        params["KernelId"] = options[:kernel_id] unless options[:kernel_id].nil?
        params["Placement.AvailabilityZone"] = options[:availability_zone] unless options[:availability_zone].nil?

        return response_generator(:action => "RunInstances", :params => params)

      end

      # If :user_data is passed in then URL escape and Base64 encode it
      # as needed.  Need for URL Escape + Base64 encoding is determined
      # by :base64_encoded param.
      def extract_user_data( options = {} )
        return unless options[:user_data]
        if options[:user_data]
          if options[:base64_encoded]
            Base64.encode64(options[:user_data]).gsub(/\n/,"").strip()
          else
            options[:user_data]
          end
        end
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


      # The RebootInstances operation requests a reboot of one or more instances. This operation is
      # asynchronous; it only queues a request to reboot the specified instance(s). The operation will succeed
      # provided the instances are valid and belong to the user. Terminated instances will be ignored.
      #
      # @option options [Array] :instance_id ([])
      #
      def reboot_instances( options = {} )

        # defaults
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

    end

  end
end

