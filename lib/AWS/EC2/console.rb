module AWS
  module EC2
    class Base < AWS::Base


      # The GetConsoleOutput operation retrieves console output that has been posted for the specified instance.
      #
      # Instance console output is buffered and posted shortly after instance boot, reboot and once the instance
      # is terminated. Only the most recent 64 KB of posted output is available. Console output is available for
      # at least 1 hour after the most recent post.
      #
      # @option options [String] :instance_id ("") an Instance ID
      #
      def get_console_output( options = {} )
        options = {:instance_id => ""}.merge(options)
        raise ArgumentError, "No instance ID provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = { "InstanceId" => options[:instance_id] }
        return response_generator(:action => "GetConsoleOutput", :params => params)
      end


    end
  end
end

