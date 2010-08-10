module AWS
  module EC2
    class Base < AWS::Base


      # The GetPasswordData operation retrieves the encrypted administrator password for the instances running Window.
      #
      # @option options [String] :instance_id ("") an Instance ID
      #
      def get_password_data( options = {} )
        options = {:instance_id => ""}.merge(options)
        raise ArgumentError, "No instance ID provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = { "InstanceId" => options[:instance_id] }
        return response_generator(:action => "GetPasswordData", :params => params)
      end


    end
  end
end
