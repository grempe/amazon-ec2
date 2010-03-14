module AWS
  module EC2
    class Base < AWS::Base

      # The DescribeSubnets operation returns information about subnets available for use by the user
      # making the request. Selected subnets may be specified or the list may be left empty if information for
      # all registered subnets is required.
      #
      # @option options [Array] :subnet_id ([])
      #
      def describe_subnets( options = {} )
        options = { :subnet_id => [] }.merge(options)
        params = pathlist("SubnetId", options[:subnet_id] )
        return response_generator(:action => "DescribeSubnets", :params => params)
      end

    end
  end
end

