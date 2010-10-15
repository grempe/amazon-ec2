module AWS
  module EC2
    class Base < AWS::Base

      # The DescribeTags operation lists the tags, If you do not specify any filters, all tags will be returned.
      #
      # @option options [optional, Array] :filters ([]) An array of Hashes representing the filters.  e.g. [{:key => 'name'}, {:resource_type => 'instance'},...]
      #
      def describe_tags( options = {} )
        params = {}
        if options[:filters]
          params.merge!(pathhashlist('Filter', options[:filters], {:key => 'key', :resource_id => 'resource-id', :resource_type => 'resource-type', :value => 'value' }))
        end
        return response_generator(:action => "DescribeTags", :params => params)
      end
    end
  end
end

