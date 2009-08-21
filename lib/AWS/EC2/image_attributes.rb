module AWS
  module EC2
    class Base < AWS::Base

      # The ModifyImageAttribute operation modifies an attribute of an AMI.  The following attributes may
      # currently be modified:
      #
      # 'launchPermission' : Controls who has permission to launch the AMI. Launch permissions can be
      # granted to specific users by adding userIds. The AMI can be made public by adding the 'all' group.
      #
      # 'productCodes' : Associates product codes with AMIs. This allows a developer to charge a user extra
      # for using the AMIs. productCodes is a write once attribute - once it has been set it can not be
      # changed or removed.  Currently only one product code is supported per AMI.
      #
      # @option options [String] :image_id ("")
      # @option options [String] :attribute ("launchPermission") An attribute to modify, "launchPermission" or "productCodes"
      # @option options [String] :operation_type ("")
      # @option options [optional, Array] :user_id ([])
      # @option options [optional, Array] :group ([])
      # @option options [optional, Array] :product_code ([])
      #
      def modify_image_attribute( options = {} )

        # defaults
        options = { :image_id => "",
                    :attribute => "launchPermission",
                    :operation_type => "",
                    :user_id => [],
                    :group => [],
                    :product_code => [] }.merge(options)

        raise ArgumentError, "No ':image_id' provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, "No ':attribute' provided" if options[:attribute].nil? || options[:attribute].empty?

        # OperationType is not required if modifying a product code.
        unless options[:attribute] == 'productCodes'
          raise ArgumentError, "No ':operation_type' provided" if options[:operation_type].nil? || options[:operation_type].empty?
        end

        params = {
          "ImageId" => options[:image_id],
          "Attribute" => options[:attribute],
          "OperationType" => options[:operation_type]
        }

        # test options provided and make sure they are valid
        case options[:attribute]
        when "launchPermission"

          unless options[:operation_type] == "add" || options[:operation_type] == "remove"
            raise ArgumentError, ":operation_type was #{options[:operation_type].to_s} but must be either 'add' or 'remove'"
          end

          if (options[:user_id].nil? || options[:user_id].empty?) && (options[:group].nil? || options[:group].empty?)
            raise ArgumentError, "Option :attribute=>'launchPermission' requires ':user_id' or ':group' options to also be specified"
          end
          params.merge!(pathlist("UserId", options[:user_id])) unless options[:user_id].nil?
          params.merge!(pathlist("Group", options[:group])) unless options[:group].nil?
        when "productCodes"
          if (options[:product_code].nil? || options[:product_code].empty?)
            raise ArgumentError, "Option :attribute=>'productCodes' requires ':product_code' to be specified"
          end
          params.merge!(pathlist("ProductCode", options[:product_code])) unless options[:product_code].nil?
        else
          raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known attribute."
        end

        return response_generator(:action => "ModifyImageAttribute", :params => params)

      end

      # The DescribeImageAttribute operation returns information about an attribute of an AMI.
      #
      # @option options [String] :image_id ("")
      # @option options [String] :attribute ("launchPermission") An attribute to describe, "launchPermission" or "productCodes"
      #
      def describe_image_attribute( options = {} )

        # defaults
        options = {:image_id => "",
                   :attribute => "launchPermission"
                   }.merge(options)

        raise ArgumentError, "No ':image_id' provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, "No ':attribute' provided" if options[:attribute].nil? || options[:attribute].empty?

        params = { "ImageId" => options[:image_id], "Attribute" => options[:attribute] }

        # test options provided and make sure they are valid
        case options[:attribute]
        when "launchPermission", "productCodes"
          # these args are ok
        else
          raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known attribute."
        end

        return response_generator(:action => "DescribeImageAttribute", :params => params)

      end


      # The ResetImageAttribute operation resets an attribute of an AMI to its default value.
      #
      # @option options [String] :image_id ("")
      # @option options [String] :attribute ("launchPermission") An attribute to reset
      #
      def reset_image_attribute( options = {} )

        # defaults
        options = {:image_id => "",
                   :attribute => "launchPermission"}.merge(options)

        raise ArgumentError, "No ':image_id' provided" if options[:image_id].nil? || options[:image_id].empty?
        raise ArgumentError, "No ':attribute' provided" if options[:attribute].nil? || options[:attribute].empty?

        params = {"ImageId" => options[:image_id],
                  "Attribute" => options[:attribute] }

        # test options provided and make sure they are valid
        case options[:attribute]
        when "launchPermission"
          # these args are ok
        else
          raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known attribute."
        end

        return response_generator(:action => "ResetImageAttribute", :params => params)

      end

    end
  end
end