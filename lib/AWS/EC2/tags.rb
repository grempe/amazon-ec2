module AWS
  module EC2
    class Base < AWS::Base


      # The DescribeTags operation lists tags
      #
      # @option options Hash 
      #
      def describe_tags( options = {} )
        params={}
        if options[:filter]
          params.merge!(pathhashlist("Filter", options[:filter], {:name => 'Name', :value => 'Value'}))
        end
        return response_generator(:action => "DescribeTags", :params => params)
      end

      # example ec2.create_tags(:resource_id => ['i-justtest'], :tag => [{:key => 'test', :value => 1}])
      def create_tags( options = {} )
        params={}
        params.merge!(pathlist("ResourceId", options[:resource_id]))
        params.merge!(pathhashlist("Tag", options[:tag], {:key => 'Key', :value => 'Value'}))
        return response_generator(:action => "CreateTags", :params => params)
      end

      # example ec2.delete_tags(:resource_id => ['i-justtest'], :tag => [{:key => 'test', :value => 1}])
      def delete_tags( options = {} )
        params={}
        params.merge!(pathlist("ResourceId", options[:resource_id]))
        params.merge!(pathhashlist("Tag", options[:tag], {:key => 'Key', :value => 'Value'}))
        return response_generator(:action => "DeleteTags", :params => params)
      end



    end
  end
end

