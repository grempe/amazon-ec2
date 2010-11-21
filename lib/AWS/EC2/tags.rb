module AWS
  module EC2
    class Base < AWS::Base

      # The CreateTags operation adds or overwrites tags for the specified resource(s).
      #
      # @option options [Array] :resource_id ([]) The ids of the resource(s) to tag
      # @option options [Array] :tag ([]) An array of Hashes representing the tags { tag_name => tag_value }. Use nil or empty string to get a tag without a value
      #
      def create_tags( options = {} )
        raise ArgumentError, "No :resource_id provided" if options[:resource_id].nil? || options[:resource_id].empty?
        raise ArgumentError, "No :tag provided" if options[:tag].nil? || options[:tag].empty?

        params = pathlist("ResourceId", options[:resource_id] )
        params.merge!(pathkvlist('Tag', options[:tag], 'Key', 'Value', {}))
        return response_generator(:action => "CreateTags", :params => params)
      end

      # The DescribeTags operation lists the tags, If you do not specify any filters, all tags will be returned.
      #
      # @option options [optional, Array] :filter ([]) An array of Hashes representing the filters. Note that the values in the hashes have to be arrays. E.g. [{:key => ['name']}, {:resource_type => ['instance']},...]
      #
      def describe_tags( options = {} )
        params = {}
        if options[:filter]
          params.merge!(pathkvlist('Filter', options[:filter], 'Name', 'Value', {:resource_id => 'resource-id', :resource_type => 'resource-type' }))
        end
        return response_generator(:action => "DescribeTags", :params => params)
      end

      # The DeleteTags operation deletes tags for the specified resource(s).
      #
      # @option options [Array] :resource_id ([]) The ids of the resource(s) to tag
      # @option options [Array] :tag ([]) An array of Hashes representing the tags { tag_name => tag_value }. If a value is given (instead of nil/empty string), then the tag is only deleted if it has this value
      #
      def delete_tags( options = {} )
        raise ArgumentError, "No :resource_id provided" if options[:resource_id].nil? || options[:resource_id].empty?
        raise ArgumentError, "No :tag provided" if options[:tag].nil? || options[:tag].empty?

        params = pathlist("ResourceId", options[:resource_id] )
        params.merge!(pathkvlist('Tag', options[:tag], 'Key', 'Value', {}))
        return response_generator(:action => "DeleteTags", :params => params)
      end
    end
  end
end

