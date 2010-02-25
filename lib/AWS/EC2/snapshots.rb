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
      # @option options [optional,String] :description ('') Description of the Amazon EBS snapshot.
      #
      def create_snapshot( options = {} )
        options = { :volume_id => '' }.merge(options)
        raise ArgumentError, "No :volume_id provided" if options[:volume_id].nil? || options[:volume_id].empty?
        params = {
          "VolumeId" => options[:volume_id]
        }
        params["Description"] = options[:description] unless options[:description].nil?
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


      # The DescribeSnapshotAttribute operation returns information about an attribute of a snapshot. Only one attribute can be specified per call.
      #
      # @option options [String] :attribute ('createVolumePermission') Attribute to modify.
      # @option options [optional,Array] :snapshot_id ([]) The ID of the Amazon EBS snapshot.
      #
      def describe_snapshot_attribute( options = {} )
        params = { "Attribute" =>  options[:attribute] || 'createVolumePermission' }
        params.merge!(pathlist("SnapshotId", options[:snapshot_id] )) unless options[:snapshot_id].nil? || options[:snapshot_id] == []
        return response_generator(:action => "DescribeSnapshotAttribute", :params => params)
      end


      # The ModifySnapshotAttribute operation adds or remove permission settings for the specified snapshot.
      #
      # @option options [String] :snapshot_id ('') The ID of the Amazon EBS snapshot.
      # @option options [String] :attribute ('createVolumePermission') Attribute to modify.
      # @option options [String] :operation_type ('') Operation to perform on the attribute.
      # @option options [optional,String] :user_id ('') Account ID of a user that can create volumes from the snapshot.
      # @option options [optional,String] :user_group ('') Group that is allowed to create volumes from the snapshot.
      #
      def modify_snapshot_attribute( options = {} )
        options = { :snapshot_id => '' }.merge(options)
        raise ArgumentError, "No :snapshot_id provided" if options[:snapshot_id].nil? || options[:snapshot_id].empty?
        options = { :operation_type => '' }.merge(options)
        raise ArgumentError, "No :operation_type provided" if options[:snapshot_id].nil? || options[:snapshot_id].empty?
	      params = {
          "Attribute" =>  options[:attribute] || 'createVolumePermission',
          "SnapshotId" => options[:snapshot_id],
          "OperationType" => options[:operation_type]
        }
        params["UserId"] = options[:user_id] unless options[:user_id].nil?
        params["UserGroup"] = options[:user_group] unless options[:user_group].nil?
        return response_generator(:action => "ModifySnapshotAttribute", :params => params)
      end


      # The ResetSnapshotAttribute operation resets permission settings for the specified snapshot.
      #
      # @option options [optional,Array] :snapshot_id ([]) The ID of the Amazon EBS snapshot.
      # @option options [String] :attribute ('createVolumePermission') Attribute to reset.
      #
      def reset_snapshot_attribute( options = {} )
        options = { :snapshot_id => '' }.merge(options)
        raise ArgumentError, "No :snapshot_id provided" if options[:snapshot_id].nil? || options[:snapshot_id].empty?
        params = { "Attribute" =>  options[:attribute] || 'createVolumePermission' }
        params["SnapshotId"] = options[:snapshot_id] unless options[:snapshot_id].nil? || options[:snapshot_id].empty?
        return response_generator(:action => "ResetSnapshotAttribute", :params => params)
      end

    end
  end
end

