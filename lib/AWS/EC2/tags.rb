module AWS
  module EC2
    class Base < AWS::Base

      # The CreateTags operation adds or overwrites tags for the specified resource(s).
      #
      # @example Tag instance i-123456789 with the name 'Test Instance'.
      #   create_tags(:resource_id => 'i-123456789',
      #               :tag         => [{'Name' => 'Test Instance'}])
      #
      # @option options [Array] :resource_id ([]) The ids of the resource(s) to tag
      # @option options [Array] :tag ([]) An array of Hashes representing the tags as string name/value pairs. Use <tt>nil</tt> or empty string to get a tag without a value
      #
      def create_tags( options = {} )
        raise ArgumentError, "No :resource_id provided" if options[:resource_id].nil? || options[:resource_id].empty?
        raise ArgumentError, "No :tag provided" if options[:tag].nil? || options[:tag].empty?

        params = pathlist("ResourceId", options[:resource_id] )
        params.merge!(pathkvlist('Tag', options[:tag], 'Key', 'Value', {}))
        return response_generator(:action => "CreateTags", :params => params)
      end

      # The DescribeTags operation lists the tags. If you do not specify any filters, all tags will be returned.
      #
      # @example Find any instances tagged with the name 'Test Instance'.
      #   describe_tags(:filter => [{'resource-type' => ['instance']},
      #                             {'key'           => ['Name']},
      #                             {'value'         => ['Test Instance']}])
      #
      # @option options [optional, Array] :filter ([]) An array of Hashes representing the filters. Note that the values in the hashes have to be arrays
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
      # @example Remove the name tag from instance i-123456789.
      #   delete_tags(:resource_id => 'i-123456789',
      #               :tag         => [{'Name' => nil}])
      #
      # @example Remove the name tag from instance i-123456789, but only if it's 'Test Instance'.
      #   delete_tags(:resource_id => 'i-123456789',
      #               :tag         => [{'Name' => 'Test Instance'}])
      #
      # @option options [Array] :resource_id ([]) The ids of the resource(s) to tag
      # @option options [Array] :tag ([]) An array of Hashes representing the tags as string name/value pairs. If a value is given (instead of <tt>nil</tt> or an empty string), then the tag is only deleted if it has the specified value
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

