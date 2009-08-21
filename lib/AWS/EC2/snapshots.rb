module AWS
  module EC2

    class Base < AWS::Base

      # The DescribeSnapshots operation describes the status of Amazon EBS snapshots.
      #
      # @option options [Array] :snapshot_id ([])
      #
      def describe_snapshots( options = {} )

        options = { :snapshot_id => [] }.merge(options)

        params = pathlist("SnapshotId", options[:snapshot_id] )

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

    end
  end
end