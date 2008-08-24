#--
# Amazon Web Services EC2 Query API Ruby library, EBS snaphshots support
#
# Ruby Gem Name::  amazon-ec2
# Author::    Yann Klis  (mailto:yann.klis@novelys.com)
# Copyright:: Copyright (c) 2008 Yann Klis
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

module EC2

  class Base

    #Amazon Developer Guide Docs:
    #
    # The DescribeSnapshots operation describes the status of Amazon EBS snapshots.
    #
    #Required Arguments:
    #
    # none
    #
    #Optional Arguments:
    #
    # :snapshot_id => Array (default : [])
    #

    def describe_snapshots( options = {} )

      options = { :snapshot_id => [] }.merge(options)

      params = pathlist("SnapshotId", options[:snapshot_id] )

      return response_generator(:action => "DescribeSnapshots", :params => params)

    end
    
    #Amazon Developer Guide Docs:
    #
    # The CreateSnapshot operation creates a snapshot of an Amazon EBS volume and stores it in Amazon S3. You can use snapshots for backups, to launch instances from identical snapshots, and to save data before shutting down an instance.
    #
    #Required Arguments:
    #
    # :volume_id => String (default : '')
    #
    #Optional Arguments:
    #
    # none
    #
    
    def create_snapshot( options = {} )

      # defaults
      options = { :volume_id => '' }.merge(options)
      
      raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?

      params = {
        "VolumeId" => options[:volume_id]
      }

      return response_generator(:action => "CreateSnapshot", :params => params)
      
    end
    
    #Amazon Developer Guide Docs:
    #
    # The DeleteSnapshot operation deletes a snapshot of an Amazon EBS  volume that is stored in Amazon S3.
    #
    #Required Arguments:
    #
    # :snapshot_id => String (default : '')
    #
    #Optional Arguments:
    #
    # none
    #
    
    def delete_snapshot( options = {} )

      options = { :snapshot_id => '' }.merge(options)
      
      raise ArgumentError, "No :snapshot_id provided" if options[:snapshot_id].nil? || options[:snapshot_id].empty?

      params = {
        "SnapshotId" => options[:snapshot_id]
      }

      return response_generator(:action => "DeleteSnapshot", :params => params)
      
    end
    
  end
end

