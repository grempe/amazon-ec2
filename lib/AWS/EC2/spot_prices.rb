module AWS
  module EC2

    class Base < AWS::Base

      # This method returns historical information about spot prices.
      # 
      # Amazon periodically sets the spot price for each instance type based on 
      # available capacity and current spot instance requests.
      #
      # @option options [Time] :start_time (nil)
      # @option options [Time] :end_time (nil)
      # @option options [String] :instance_type (nil)
      # @option options [String] :product_description (nil)
      #
      def describe_spot_price_history( options = {} )
        raise ArgumentError, ":start_time must be a Time object" unless options[:start_time].nil? || options[:start_time].kind_of?(Time)
        raise ArgumentError, ":end_time must be a Time object" unless options[:end_time].nil? || options[:end_time].kind_of?(Time)
        raise ArgumentError, ":instance_type must specify a valid instance type" unless options[:instance_type].nil? || ["t1.micro", "m1.small", "m1.large", "m1.xlarge", "m2.xlarge", "c1.medium", "c1.xlarge", "m2.2xlarge", "m2.4xlarge", "cc1.4xlarge"].include?(options[:instance_type])
        raise ArgumentError, ":product_description must be 'Linux/UNIX' or 'Windows'" unless options[:product_description].nil? || ["Linux/UNIX", "Windows"].include?(options[:product_description])

        params = {}
        params.merge!("StartTime" => options[:start_time].iso8601) if options[:start_time]
        params.merge!("EndTime" => options[:end_time].iso8601) if options[:end_time]
        params.merge!("InstanceType" => options[:instance_type]) if options[:instance_type]
        params.merge!("ProductDescription" => options[:product_description]) if options[:product_description]

        return response_generator(:action => "DescribeSpotPriceHistory", :params => params)
      end

    end
  end
end

