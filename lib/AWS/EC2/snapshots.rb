module AWS
  module EC2

    class Base < AWS::Base


      # The DescribeSnapshots operation describes the status of Amazon EBS snapshots.
      #
      # @option options [optional,Array] :snapshot_id ([]) The ID of the Amazon EBS snapshot.
      # @option options [optional,String] :owner ('') Returns snapshots owned by the specified owner. Multiple owners can be specified. Valid values self | amazon | AWS Account ID
      # @option options [optional,String] :restorable_by ('') Account ID of a user that can create volumes from the snapshot.
      #
      def describe_snapshots( options = {} )
        params = {}
        params.merge!(pathlist("SnapshotId", options[:snapshot_id] )) unless options[:snapshot_id].nil? || options[:snapshot_id] == []
        params["RestorableBy"] = options[:restorable_by] unless options[:restorable_by].nil?
        params["Owner"] = options[:owner] unless options[:owner].nil?
        return response_generator(:action => "DescribeSnapshots", :params => params)
      end


      # The CreateSnapshot operation creates a snapshot of an Amazon EBS volume and stores it in Amazon S3. You can use snapshots for backups, to launch instances from identical snapshots, and to save data before shutting down an instance.
      #
      # @option options [String] :volume_id ('')
      #
      def create_snapshot( options = {} )
        options = { :volume_id => '' }.merge(options)
        raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?
        params = {
          "VolumeId" => options[:volume_id]
        }
        return response_generator(:action => "CreateSnapshot", :params => params)
      end


      # The DeleteSnapshot operation deletes a snapshot of an Amazon EBS  volume that is stored in Amazon S3.
      #
      # @option options [String] :snapshot_id ('')
      #
      def delete_snapshot( options = {} )
        options = { :snapshot_id => '' }.merge(options)
        raise ArgumentError, "No :snapshot_id provided" if options[:snapshot_id].nil? || options[:snapshot_id].empty?
        params = {
          "SnapshotId" => options[:snapshot_id]
        }
        return response_generator(:action => "DeleteSnapshot", :params => params)
      end


      # Not yet implemented
      #
      # @todo Implement this method
      #
      def describe_snapshot_attribute( options = {} )
        raise "Not yet implemented"
      end


      # Not yet implemented
      #
      # @todo Implement this method
      #
      def modify_snapshot_attribute( options = {} )
        raise "Not yet implemented"
      end


      # Not yet implemented
      #
      # @todo Implement this method
      #
      def reset_snapshot_attribute( options = {} )
        raise "Not yet implemented"
      end


    end
  end
end

