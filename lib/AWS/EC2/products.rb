module AWS
  module EC2
    class Base < AWS::Base

      # The ConfirmProductInstance operation returns true if the given product code is attached to the instance
      # with the given instance id. False is returned if the product code is not attached to the instance.
      #
      # @option options [String] :product_code ("")
      # @option options [String] :instance_id ("")
      #
      def confirm_product_instance( options ={} )
        options = {:product_code => "", :instance_id => ""}.merge(options)
        raise ArgumentError, "No product code provided" if options[:product_code].nil? || options[:product_code].empty?
        raise ArgumentError, "No instance ID provided" if options[:instance_id].nil? || options[:instance_id].empty?
        params = { "ProductCode" => options[:product_code], "InstanceId" => options[:instance_id] }
        return response_generator(:action => "ConfirmProductInstance", :params => params)
      end

    end
  end
end