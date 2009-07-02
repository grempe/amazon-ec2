#--
# Amazon Web Services EC2 Query API Ruby library, EBS volumes support
#
# Ruby Gem Name::  amazon-ec2
# Author::    Yann Klis  (mailto:yann.klis@novelys.com)
# Copyright:: Copyright (c) 2008 Yann Klis
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

module AWS
  module EC2

    class Base < AWS::Base

      #Amazon Developer Guide Docs:
      #
      # The DescribeVolumes operation lists one or more Amazon EBS volumes that you own, If you do not specify any volumes, Amazon EBS returns all volumes that you own.
      #
      #Required Arguments:
      #
      # none
      #
      #Optional Arguments:
      #
      # :volume_id => Array (default : [])
      #

      def describe_volumes( options = {} )

        options = { :volume_id => [] }.merge(options)

        params = pathlist("VolumeId", options[:volume_id] )

        return response_generator(:action => "DescribeVolumes", :params => params)

      end

      #Amazon Developer Guide Docs:
      #
      # The CreateVolume operation creates a new Amazon EBS volume that you can mount from any Amazon EC2 instance.
      #
      #Required Arguments:
      #
      # :availability_zone => String (default : '')
      #
      #Optional Arguments:
      #
      # :size => String (default : '')
      # :snapshot_id => String (default : '')
      #

      def create_volume( options = {} )

        # defaults
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

      #Amazon Developer Guide Docs:
      #
      # The DeleteVolume operation deletes an Amazon EBS volume.
      #
      #Required Arguments:
      #
      # :volume_id => String (default : '')
      #
      #Optional Arguments:
      #
      # none
      #

      def delete_volume( options = {} )

        options = { :volume_id => '' }.merge(options)

        raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?

        params = {
          "VolumeId" => options[:volume_id]
        }

        return response_generator(:action => "DeleteVolume", :params => params)

      end

      #Amazon Developer Guide Docs:
      #
      # The AttachVolume operation attaches an Amazon EBS volume to an instance.
      #
      #Required Arguments:
      #
      # :volume_id => String (default : '')
      # :instance_id => String (default : '')
      # :device => String (default : '')
      #
      #Optional Arguments:
      #
      # none
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

      #Amazon Developer Guide Docs:
      #
      # The DetachVolume operation detaches an Amazon EBS volume from an instance.
      #
      #Required Arguments:
      #
      # :volume_id => String (default : '')
      #
      #Optional Arguments:
      #
      # :instance_id => String (default : '')
      # :device => String (default : '')
      # :force => Boolean (default : '')
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
          "Force" => options[:force]
        }

        return response_generator(:action => "DetachVolume", :params => params)

      end
    end
  end
end