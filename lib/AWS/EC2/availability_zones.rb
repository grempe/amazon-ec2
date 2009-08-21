module AWS
  module EC2
    class Base < AWS::Base

      # The DescribeAvailabilityZones operation describes availability zones that are currently
      # available to the account and their states.
      #
      # An optional list of zone names can be passed.
      #
      # @option options [optional, String] :zone_name ([]) an Array of zone names
      #
      def describe_availability_zones( options = {} )
        options = { :zone_name => [] }.merge(options)
        params = pathlist("ZoneName", options[:zone_name] )
        return response_generator(:action => "DescribeAvailabilityZones", :params => params)
      end

    end
  end
end

