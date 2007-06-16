#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Elastic Workbench, LLC
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

module EC2
  
  class AWSAuthConnection
    
    #Amazon Developer Guide Docs:
    #  
    # The ModifyImageAttribute operation modifies an attribute of an AMI. 
    # Currently the only attribute supported is launchPermission. By modifying this attribute it is possible to 
    # make an AMI public or to grant specific users launch permissions for the AMI. To make the AMI public 
    # add the group=all attribute item. To grant launch permissions for a specific user add a 
    # userId=<userid> attribute item.
    #
    #Required Arguments:
    #
    # :image_id => String (default : "")
    # :attribute => String (default : "launchPermission")
    # :operation_type => String (default : "add")
    #
    #Optional Arguments:
    #
    # :user_id => Array (default : [])
    # :group => Array (default : [])
    #
    def modify_image_attribute( options = {} )
      
      # defaults
      options = { :image_id => "", 
                  :attribute => "launchPermission", 
                  :operation_type => "add", 
                  :user_id => [], 
                  :group => [] }.merge(options)
      
      raise ArgumentError, "No ':image_id' provided" if options[:image_id].nil? || options[:image_id].empty?
      raise ArgumentError, "No ':attribute' provided" if options[:attribute].nil? || options[:attribute].empty?
      raise ArgumentError, "No ':operation_type' provided" if options[:operation_type].nil? || options[:operation_type].empty?
      
      params = {
        "ImageId" => options[:image_id],
        "Attribute" => options[:attribute],
        "OperationType" => options[:operation_type]
      }
      
      # test options provided and make sure they are valid
      case options[:attribute]
      when "launchPermission"
        if (options[:user_id].nil? || options[:user_id].empty?) && (options[:group].nil? || options[:group].empty?)
          raise ArgumentError, "Option :attribute=>'launchPermission' requires ':user_id' or ':group' options to also be specified"
        end
        
        params.merge!(pathlist("UserId", options[:user_id])) unless options[:user_id].nil?
        params.merge!(pathlist("Group", options[:group])) unless options[:group].nil?
      else
        raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known option."
      end
      
      # test options provided and make sure they are valid
      case options[:operation_type]
      when "add", "remove"
        # these args are ok
      else
        raise ArgumentError, ":operation_type was #{options[:operation_type].to_s} but must be 'add' or 'remove'"
      end
      
      return response_generator(:action => "ModifyImageAttribute", :params => params)
      
    end
    
    #Amazon Developer Guide Docs:
    #
    # The DescribeImageAttribute operation returns information about an attribute of an AMI.
    #
    #Required Arguments:
    #
    # :image_id => String (default : "")
    # :attribute => String (default : "launchPermission")
    #
    #Optional Arguments:
    #
    # none
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
      when "launchPermission"
        # these args are ok
      else
        raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known option."
      end
      
      return response_generator(:action => "DescribeImageAttribute", :params => params)
      
    end
    
    
    #Amazon Developer Guide Docs:
    #
    # The ResetImageAttribute operation resets an attribute of an AMI to its default value.
    #
    #Required Arguments:
    #
    # :image_id => String (default : "")
    # :attribute => String (default : "launchPermission")
    #
    #Optional Arguments:
    #
    # none
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
        raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known option."
      end
      
      return response_generator(:action => "ResetImageAttribute", :params => params)
      
    end
    
  end
  
end
