module AWS
  module EC2
    class Base < AWS::Base


      # The DescribeVolumes operation lists one or more Amazon EBS volumes that you own, If you do not specify any volumes, Amazon EBS returns all volumes that you own.
      #
      # @option options [optional, String] :volume_id ([])
      #
      def describe_volumes( options = {} )
        options = { :volume_id => [] }.merge(options)
        params = pathlist("VolumeId", options[:volume_id] )
        return response_generator(:action => "DescribeVolumes", :params => params)
      end


      # The CreateVolume operation creates a new Amazon EBS volume that you can mount from any Amazon EC2 instance.
      #
      # @option options [String] :availability_zone ('')
      # @option options [optional, String] :size ('')
      # @option options [optional, String] :snapshot_id ('')
      #
      def create_volume( options = {} )
        options = { :availability_zone => '' }.merge(options)
        raise ArgumentError, "No :availability_zone provided" if options[:availability_zone].nil? || options[:availability_zone].empty?
        options = { :size => '' }.merge(options)
        options = { :snapshot_id => '' }.merge(options)
        params = {
          "AvailabilityZone" => options[:availability_zone],
          "Size" => options[:size],
          "SnapshotId" => options[:snapshot_id]
        }
        return response_generator(:action => "CreateVolume", :params => params)
      end


      # The DeleteVolume operation deletes an Amazon EBS volume.
      #
      # @option options [String] :volume_id ('')
      #
      def delete_volume( options = {} )
        options = { :volume_id => '' }.merge(options)
        raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?
        params = {
          "VolumeId" => options[:volume_id]
        }
        return response_generator(:action => "DeleteVolume", :params => params)
      end


      # The AttachVolume operation attaches an Amazon EBS volume to an instance.
      #
      # @option options [String] :volume_id ('')
      # @option options [String] :instance_id ('')
      # @option options [String] :device ('')
      #
      def attach_volume( options = {} )
        options = { :volume_id => '' }.merge(options)
        options = { :instance_id => '' }.merge(options)
        options = { :device => '' }.merge(options)
        raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?
        raise ArgumentError, "No :instance_id provided" if options[:instance_id].nil? || options[:instance_id].empty?
        raise ArgumentError, "No :device provided" if options[:device].nil? || options[:device].empty?

        params = {
          "VolumeId" => options[:volume_id],
          "InstanceId" => options[:instance_id],
          "Device" => options[:device]
        }
        return response_generator(:action => "AttachVolume", :params => params)
      end


      # The DetachVolume operation detaches an Amazon EBS volume from an instance.
      #
      # @option options [String] :volume_id ('')
      # @option options [optional, String] :instance_id ('')
      # @option options [optional, String] :device ('')
      # @option options [optional, Boolean] :force ('')
      #
      def detach_volume( options = {} )
        options = { :volume_id => '' }.merge(options)
        raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?
        options = { :instance_id => '' }.merge(options)
        options = { :device => '' }.merge(options)
        options = { :force => '' }.merge(options)
        params = {
          "VolumeId" => options[:volume_id],
          "InstanceId" => options[:instance_id],
          "Device" => options[:device],
          "Force" => options[:force].to_s
        }
        return response_generator(:action => "DetachVolume", :params => params)
      end


    end
  end
end

