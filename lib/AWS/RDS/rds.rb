module AWS
  module RDS
    class Base < AWS::Base

      # This API creates a new DB instance. Once the call has completed
      # successfully, a new DB instance will be created, but it will not be
      #
      # @option options [String] :db_instance_identifier (nil) the name of the db_instance
      # @option options [String] :allocated_storage in gigabytes (nil)
      # @option options [String] :db_instance_class in contains compute and memory capacity (nil)
      # @option options [String] :engine type i.e. MySQL5.1 (nil)
      # @option options [String] :master_username is the master username for the db instance (nil)
      # @option options [String] :master_user_password is the master password for the db instance (nil)
      # @option options [String] :port is the port the database accepts connections on (3306)
      # @option options [String] :db_name contains the name of the database to create when created (nil)
      # @option options [String] :db_parameter_group is the database parameter group to associate with this instance (nil)
      # @option options [Array] :db_security_groups are the list of db security groups to associate with the instance (nil)
      # @option options [String] :availability_zone is the availability_zone to create the instance in (nil)
      # @option options [String] :preferred_maintenance_window in format: ddd:hh24:mi-ddd:hh24:mi (nil)
      # @option options [String] :backup_retention_period is the number of days which automated backups are retained (1)
      # @option options [String] :preferred_backup_window is the daily time range for which automated backups are created
      #
      def create_db_instance( options = {})
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier)
        raise ArgumentError, "No :allocated_storage provided" if options.does_not_have?(:allocated_storage)
        raise ArgumentError, "No :db_instance_class provided" if options.does_not_have?(:db_instance_class)
        raise ArgumentError, "No :engine provided" if options.does_not_have?(:engine)
        raise ArgumentError, "No :master_username provided" if options.does_not_have?(:master_username)
        raise ArgumentError, "No :master_user_password provided" if options.does_not_have?(:master_user_password)
        raise ArgumentError, "No :db_instance_class provided" if options.does_not_have?(:db_instance_class)

        # handle a former argument that was misspelled
        raise ArgumentError, "Perhaps you meant :backup_retention_period" if options.has?(:backend_retention_period)

        params = {}
        params['DBInstanceIdentifier'] = options[:db_instance_identifier]
        params["AllocatedStorage"] = options[:allocated_storage].to_s
        params["DBInstanceClass"] = options[:db_instance_class]
        params["Engine"] = options[:engine]
        params["MasterUsername"] = options[:master_username]
        params["MasterUserPassword"] = options[:master_user_password]

        params["Port"] = options[:port].to_s if options.has?(:port)
        params["DBName"] = options[:db_name] if options.has?(:db_name)
        params["DBParameterGroup"] = options[:db_parameter_group] if options.has?(:db_parameter_group)
        params.merge!(pathlist("DBSecurityGroups.member", [options[:db_security_groups]].flatten)) if options.has_key?(:db_security_groups)
        params["AvailabilityZone"] = options[:availability_zone] if options.has?(:availability_zone)
        params["PreferredMaintenanceWindow"] = options[:preferred_maintenance_window] if options.has?(:preferred_maintenance_window)
        params["BackupRetentionPeriod"] = options[:backup_retention_period].to_s if options.has?(:backup_retention_period)
        params["PreferredBackupWindow"] = options[:preferred_backup_window] if options.has?(:preferred_backup_window)

        return response_generator(:action => "CreateDBInstance", :params => params)
      end

      # This API method deletes a db instance identifier
      #
      # @option options [String] :db_instance_identifier is the instance identifier for the DB instance to be deleted (nil)
      # @option options [String] :skip_final_snapshot determines to create a snapshot or not before it's deleted (no)
      # @option options [String] :final_db_snapshot_identifier is the name of the snapshot created before the instance is deleted (name)
      #
      def delete_db_instance( options = {} )
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier)

        params = {}
        params['DBInstanceIdentifier'] = options[:db_instance_identifier]

        params["SkipFinalSnapshot"] = options[:skip_final_snapshot].to_s if options.has?(:skip_final_snapshot)
        params["FinalDBSnapshotIdentifier"] = options[:final_db_snapshot_identifier].to_s if options.has?(:final_db_snapshot_identifier)

        return response_generator(:action => "DeleteDBInstance", :params => params)
      end

      # This API method creates a db parameter group
      #
      # @option options [String] :db_parameter_group_name is the name of the parameter group (nil)
      # @option options [String] :engine is the engine the db parameter group can be used with (nil)
      # @option options [String] :description is the description of the paramter group
      #
      def create_db_parameter_group( options = {} )
        raise ArgumentError, "No :db_parameter_group_name provided" if options.does_not_have?(:db_parameter_group_name)
        raise ArgumentError, "No :engine provided" if options.does_not_have?(:engine)
        raise ArgumentError, "No :description provided" if options.does_not_have?(:description)

        params = {}
        params['DBParameterGroupName'] = options[:db_parameter_group_name]
        params['Engine'] = options[:engine]
        params['Description'] = options[:description]

        return response_generator(:action => "CreateDBParameterGroup", :params => params)
      end

      # This API method creates a db security group
      #
      # @option options [String] :db_security_group_name is the name of the db security group (nil)
      # @option options [String] :db_security_group_description is the description of the db security group
      #
      def create_db_security_group( options = {} )
        raise ArgumentError, "No :db_security_group_name provided" if options.does_not_have?(:db_security_group_name)
        raise ArgumentError, "No :db_security_group_description provided" if options.does_not_have?(:db_security_group_description)

        params = {}
        params['DBSecurityGroupName'] = options[:db_security_group_name]
        params['DBSecurityGroupDescription'] = options[:db_security_group_description]

        return response_generator(:action => "CreateDBSecurityGroup", :params => params)
      end

      # This API method creates a restoreable db snapshot
      #
      # @option options [String] :db_snapshot_identifier is the identifier of the db snapshot
      # @option options [String] :db_instance_identifier is the identifier of the db instance
      #
      def create_db_snapshot( options = {} )
        raise ArgumentError, "No :db_snapshot_identifier provided" if options.does_not_have?(:db_snapshot_identifier)
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier)

        params = {}
        params['DBSnapshotIdentifier'] = options[:db_snapshot_identifier]
        params['DBInstanceIdentifier'] = options[:db_instance_identifier]

        return response_generator(:action => "CreateDBSnapshot", :params => params)
      end

      # This API method authorizes network ingress for an amazon ec2 group
      #
      # @option options [String] :db_security_group_name is the name of the db security group
      # @option options [String] :cidrip is the network ip to authorize
      # @option options [String] :ec2_security_group_name is the name of the ec2 security group to authorize
      # @option options [String] :ec2_security_group_owner_id is the owner id of the security group
      #
      def authorize_db_security_group( options = {} )
        raise ArgumentError, "No :db_security_group_name provided" if options.does_not_have?(:db_security_group_name)

        params = {}
        params['DBSecurityGroupName'] = options[:db_security_group_name]

        if options.has?(:cidrip)
          params['CIDRIP'] = options[:cidrip]
        elsif options.has?(:ec2_security_group_name) && options.has?(:ec2_security_group_owner_id)
          params['EC2SecurityGroupName'] = options[:ec2_security_group_name]
          params['EC2SecurityGroupOwnerId'] = options[:ec2_security_group_owner_id]
        else
          raise ArgumentError, "No :cidrip or :ec2_security_group_name and :ec2_security_group_owner_id provided"
        end

        return response_generator(:action => "AuthorizeDBSecurityGroupIngress", :params => params)
      end

      # This API method deletes a db paramter group
      #
      # @option options [String] :db_parameter_group_name is the name of the db paramter group to be deleted (nil)
      #
      def delete_db_parameter_group( options = {} )
        raise ArgumentError, "No :db_parameter_group_name provided" if options.does_not_have?(:db_parameter_group_name)

        params = {}
        params['DBParameterGroupName'] = options[:db_parameter_group_name]

        return response_generator(:action => "DeleteDBParameterGroup", :params => params)
      end

      # This API method deletes a db security group
      #
      # @option options [String] :db_security_group_name is the name of the db security group to be deleted (nil)
      #
      def delete_db_security_group( options = {} )
        raise ArgumentError, "No :db_security_group_name provided" if options.does_not_have?(:db_security_group_name)

        params = {}
        params['DBSecurityGroupName'] = options[:db_security_group_name]

        return response_generator(:action => "DeleteDBSecurityGroup", :params => params)
      end

      # This API method deletes a db snapshot
      #
      # @option options [String] :db_snapshot_identifier is the name of the db snapshot to be deleted (nil)
      #
      def delete_db_snapshot( options = {} )
        raise ArgumentError, "No :db_snapshot_identifier provided" if options.does_not_have?(:db_snapshot_identifier)

        params = {}
        params['DBSnapshotIdentifier'] = options[:db_snapshot_identifier]

        return response_generator(:action => "DeleteDBSnapshot", :params => params)
      end

      # This API method describes the db instances
      #
      # @option options [String] :db_instance_identifier if passed, only the description for the db instance matching this identifier is returned
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_db_instances( options = {} )
        params = {}
        params['DBInstanceIdentifier'] = options[:db_instance_identifier] if options.has?(:db_instance_identifier)
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeDBInstances", :params => params)
      end

      # This API method describes the default engine parameters
      #
      # @option options [String] :engine is the name of the database engine
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_engine_default_parameters( options = {} )
        raise ArgumentError, "No :engine provided" if options.does_not_have?(:engine)

        params = {}
        params['Engine'] = options[:engine]
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeEngineDefaultParameters", :params => params)
      end

      # This API method returns information about all DB Parameter Groups for an account if no
      # DB Parameter Group name is supplied, or displays information about a specific named DB Parameter Group.
      # You can call this operation recursively using the Marker parameter.
      #
      # @option options [String] :db_parameter_group_name is the name of the parameter group
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_db_parameter_groups( options = {} )
        params = {}
        params['DBParameterGroupName'] = options[:db_parameter_group_name] if options.has?(:db_parameter_group_name)
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeDBParameterGroups", :params => params)
      end

      # This API method returns information about parameters that are part of a parameter group.
      # You can optionally request only parameters from a specific source.
      # You can call this operation recursively using the Marker parameter.
      #
      # @option options [String] :db_parameter_group_name is the name parameter group
      # @option options [String] :source is the type of parameter to return
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_db_parameters( options = {} )
        raise ArgumentError, "No :db_parameter_group_name provided" if options.does_not_have?(:db_parameter_group_name)

        params = {}
        params['DBParameterGroupName'] = options[:db_parameter_group_name]
        params['Source'] = options[:source] if options.has?(:source)
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeDBParameters", :params => params)
      end

      # This API method returns all the DB Security Group details for a particular AWS account,
      # or for a particular DB Security Group if a name is specified.
      # You can call this operation recursively using the Marker parameter.
      #
      # @option options [String] :db_security_group_name is the name of the security group
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_db_security_groups( options = {} )
        params = {}
        params['DBSecurityGroupName'] = options[:db_security_group_name] if options.has?(:db_security_group_name)
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeDBSecurityGroups", :params => params)
      end

      # This API method returns information about the DB Snapshots for this account.
      # If you pass in a DBInstanceIdentifier, it returns information only about DB Snapshots taken for that DB Instance.
      # If you pass in a DBSnapshotIdentifier,it will return information only about the specified snapshot.
      # If you omit both DBInstanceIdentifier and DBSnapshotIdentifier, it returns all snapshot information for all
      # database instances, up to the maximum number of records specified. Passing both DBInstanceIdentifier and
      # DBSnapshotIdentifier results in an error.
      #
      # @option options [String] :db_instance_identifier is the unique identifier that identifies a DB instance
      # @option options [String] :db_snapshot_identifier is a unique identifier for an amazon RDS snapshot
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_db_snapshots( options = {} )
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier)

        params = {}
        params['DBInstanceIdentifier'] = options[:db_instance_identifier]

        params['DBSnapshotIdentifier'] = options[:db_snapshot_identifier] if options.has?(:db_snapshot_identifier)
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeDBSnapshots", :params => params)
      end

      # This API method Returns information about events related to your DB Instances, DB Security Groups,
      # and DB Parameter Groups for up to the past 14 days.
      # You can get events specific to a particular DB Instance or DB Security Group by providing the name as a parameter.
      # By default, the past hour of events are returned.
      #
      # If neither DBInstanceIdentifier or DBSecurityGroupName are provided,
      # all events are be retrieved for DB Instances and DB Security Groups.
      #
      # @option options [String] :source_identifier is the identifier for the source for which events will be included
      # @option options [String] :source_type is the type of event sources to return
      # @option options [String] :start_time is the beginning of the time interval to return records for (ISO 8601 format)
      # @option options [String] :end_time is the end of the time interval to return records (ISO 8601 format)
      # @option options [String] :duration is the number of minutes to return events for.
      # @option options [String] :max_records is the maximum number of records to include in the response
      # @option options [String] :marker provided in the previous request
      #
      def describe_events( options = {} )
        params = {}
        params['SourceIdentifier'] = options[:source_identifier] if options.has?(:source_identifier)
        params['SourceType'] = options[:source_type] if options.has?(:source_type)
        params['StartTime'] = options[:start_time] if options.has?(:start_time)
        params['EndTime'] = options[:end_time] if options.has?(:end_time)
        params['Duration'] = options[:duration] if options.has?(:duration)
        params['MaxRecords'] = options[:max_records].to_s if options.has?(:max_records)
        params['Marker'] = options[:marker] if options.has?(:marker)

        return response_generator(:action => "DescribeEvents", :params => params)
      end

      # This API changes the settings of an existing DB Instance.
      #
      # Changes are applied in the following manner: A ModifyDBInstance API call to modify security groups or to
      # change the maintenance windows results in immediate action. Modification of the DB Parameter Group applies
      # immediate parameters as soon as possible and pending-reboot parameters only when the RDS instance is rebooted.
      # A request to scale the DB Instance class results puts the database instance into the modifying state.
      #
      # The DB Instance must be in available or modifying state for this API to accept changes.
      #
      # @option options [String] :db_instance_identifier (nil) the name of the db_instance
      # @option options [String] :allocated_storage in gigabytes (nil)
      # @option options [String] :db_instance_class in contains compute and memory capacity (nil)
      # @option options [String] :engine type i.e. MySQL5.1 (nil)
      # @option options [String] :master_username is the master username for the db instance (nil)
      # @option options [String] :master_user_password is the master password for the db instance (nil)
      # @option options [String] :port is the port the database accepts connections on (3306)
      # @option options [String] :db_name contains the name of the database to create when created (nil)
      # @option options [String] :db_parameter_group_name is the database parameter group to associate with this instance (nil)
      # @option options [Array] :db_security_groups are the list of db security groups to associate with the instance (nil)
      # @option options [String] :availability_zone is the availability_zone to create the instance in (nil)
      # @option options [String] :preferred_maintenance_window in format: ddd:hh24:mi-ddd:hh24:mi (nil)
      # @option options [String] :backup_retention_period is the number of days which automated backups are retained (1)
      # @option options [String] :preferred_backup_window is the daily time range for which automated backups are created
      #
      def modify_db_instance( options = {})
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier)

        # handle a former argument that was misspelled
        raise ArgumentError, "Perhaps you meant :backup_retention_period" if options.has?(:backend_retention_period)

        params = {}
        params['DBInstanceIdentifier'] = options[:db_instance_identifier]

        params["AllocatedStorage"] = options[:allocated_storage].to_s if options.has?(:allocated_storage)
        params["DBInstanceClass"] = options[:db_instance_class] if options.has?(:db_instance_class)
        params["Engine"] = options[:engine] if options.has?(:engine)
        params["MasterUsername"] = options[:master_username] if options.has?(:master_username)
        params["MasterUserPassword"] = options[:master_user_password] if options.has?(:master_user_password)
        params["Port"] = options[:port].to_s if options.has?(:port)
        params["DBName"] = options[:db_name] if options.has?(:db_name)
        params["DBParameterGroupName"] = options[:db_parameter_group_name] if options.has?(:db_parameter_group_name)
        params.merge!(pathlist("DBSecurityGroups.member", [options[:db_security_groups]].flatten)) if options.has_key?(:db_security_groups)
        params["AvailabilityZone"] = options[:availability_zone] if options.has?(:availability_zone)
        params["PreferredMaintenanceWindow"] = options[:preferred_maintenance_window] if options.has?(:preferred_maintenance_window)
        params["BackupRetentionPeriod"] = options[:backup_retention_period].to_s if options.has?(:backup_retention_period)
        params["PreferredBackupWindow"] = options[:preferred_backup_window] if options.has?(:preferred_backup_window)

        return response_generator(:action => "ModifyDBInstance", :params => params)
      end

      # This API method modifies the parameters of a DB Parameter Group.
      # To modify more than one parameter, submit a list of the following: ParameterName, ParameterValue, and ApplyMethod.
      # You can modify a maximum of 20 parameters in a single request.
      #
      # @option options [String] :db_parameter_group_name is the name of the parameter group to modify
      # @option options [String] :parameters is the array of parameters to update in a hash format
      #   {:name => "ParameterName", :value => "ParameterValue", :apply_method => "pending-reboot"}
      #
      def modify_db_parameter_group( options = {} )
        raise ArgumentError, "No :db_parameter_group_name provided" if options.does_not_have?(:db_parameter_group_name)
        raise ArgumentError, "No :parameters provided" if options.does_not_have?(:parameters)

        params = {}
        params['DBParameterGroupName'] = options[:db_parameter_group_name]
        params.merge!(pathhashlist('Parameters.member', [options[:parameters]].flatten, {
          :name => 'ParameterName',
          :value => 'ParameterValue',
          :apply_method => "ApplyMethod"
        }))

        return response_generator(:action => "ModifyDBParameterGroup", :params => params)
      end

      # This API method reboots a DB Instance.
      # Once started, the process cannot be stopped, and the database instance will be unavailable until the reboot completes.
      #
      # @option options [String] :db_instance_identifier is the identifier for the db instance to restart
      #
      def reboot_db_instance( options = {} )
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier
        )
        params = {}
        params['DBInstanceIdentifier'] = options[:db_instance_identifier] if options.has?(:db_instance_identifier)

        return response_generator(:action => "RebootDBInstance", :params => params)
      end

      # This API method modifies the parameters of a DB Parameter Group.
      # To modify more than one parameter, submit a list of the following: ParameterName, ParameterValue, and ApplyMethod.
      # You can modify a maximum of 20 parameters in a single request.
      #
      # @option options [String] :db_parameter_group_name is the name of the parameter group to modify
      # @option options [String] :reset_all_parameters specified whether to reset all the db parameters
      # @option options [String] :parameters is the array of parameters to update in a hash format
      #   {:name => "ParameterName", :apply_method => "pending-reboot"}
      #
      def reset_db_parameter_group( options = {} )
        raise ArgumentError, "No :db_parameter_group_name provided" if options.does_not_have?(:db_parameter_group_name)
        raise ArgumentError, "No :parameters provided" if options.does_not_have?(:parameters)

        params = {}
        params['DBParameterGroupName'] = options[:db_parameter_group_name]
        params.merge!(pathhashlist('Parameters.member', [options[:parameters]].flatten, {
          :name => 'ParameterName',
          :apply_method => "ApplyMethod"
        }))
        params['ResetAllParameters'] = options[:reset_all_parameters] if options.has?(:reset_all_parameters)

        return response_generator(:action => "ResetDBParameterGroup", :params => params)
      end

      # This API method restores a db instance to a snapshot of the instance
      #
      # @option options [String] :db_snapshot_identifier is the db identifier of the snapshot to restore from
      # @option options [String] :db_instance_identifier is the identifier of the db instance
      # @option options [String] :db_instance_class is the class of db compute and memory instance for the db instance
      # @option options [String] :port is the port which the db can accept connections on
      # @option options [String] :availability_zone is the EC2 zone which the db instance will be created
      #
      def restore_db_instance_from_snapshot( options = {} )
        raise ArgumentError, "No :db_snapshot_identifier provided" if options.does_not_have?(:db_snapshot_identifier)
        raise ArgumentError, "No :db_instance_identifier provided" if options.does_not_have?(:db_instance_identifier)
        raise ArgumentError, "No :db_instance_class provided" if options.does_not_have?(:db_instance_class)

        params = {}
        params['DBSnapshotIdentifier'] = options[:db_snapshot_identifier]
        params['DBInstanceIdentifier'] = options[:db_instance_identifier]
        params['DBInstanceClass'] = options[:db_instance_class]

        params['Port'] = options[:port].to_s if options.has?(:port)
        params['AvailabilityZone'] = options[:availability_zone] if options.has?(:availability_zone)

        return response_generator(:action => "RestoreDBInstanceFromDBSnapshot", :params => params)
      end

      # This API method restores a DB Instance to a specified time, creating a new DB Instance.
      #
      # Some characteristics of the new DB Instance can be modified using optional parameters.
      # If these options are omitted, the new DB Instance defaults to the characteristics of the DB Instance from which the
      # DB Snapshot was created.
      #
      # @option options [String] :source_db_instance_identifier the identifier of the source DB Instance from which to restore.
      # @option options [optional, Boolean] :use_latest_restorable_time specifies that the db be restored to the latest restored time. Conditional, cannot be specified if :restore_time parameter is provided.
      # @option options [optional, Date] :restore_time specifies the date and time to restore from. Conditional, cannot be specified if :use_latest_restorable_time parameter is true.
      # @option options [String] :target_db_instance_identifier is the name of the new database instance to be created.
      # @option options [optional, String] :db_instance_class specifies the class of the compute and memory of the EC2 instance, Options : db.m1.small | db.m1.large | db.m1.xlarge | db.m2.2xlarge | db.m2.4xlarge | db.cc1.4xlarge
      # @option options [optional, Integer] :port is the port which the db can accept connections on. Constraints: Value must be 1115-65535
      # @option options [optional, String] :availability_zone is the EC2 zone which the db instance will be created
      #
      def restore_db_instance_to_point_in_time( options = {} )
        raise ArgumentError, "No :source_db_instance_identifier provided" if options.does_not_have?(:source_db_instance_identifier)
        raise ArgumentError, "No :target_db_instance_identifier provided" if options.does_not_have?(:target_db_instance_identifier)

        params = {}
        params['SourceDBInstanceIdentifier'] = options[:source_db_instance_identifier]
        params['TargetDBInstanceIdentifier'] = options[:target_db_instance_identifier]

        if options.has?(:use_latest_restorable_time) && options.has?(:restore_time)
          raise ArgumentError, "You cannot provide both :use_latest_restorable_time and :restore_time"
        elsif options.has?(:use_latest_restorable_time)
          params['UseLatestRestorableTime'] = case options[:use_latest_restorable_time]
                                              when 'true', 'false'
                                                options[:use_latest_restorable_time]
                                              when true
                                                'true'
                                              when false
                                                'false'
                                              else
                                                raise ArgumentError, "Invalid value provided for :use_latest_restorable_time.  Expected boolean."
                                              end
        elsif options.has?(:restore_time)
          params['RestoreTime'] = options[:restore_time]
        end

        params['DBInstanceClass'] = options[:db_instance_class] if options.has?(:db_instance_class)
        params['Port'] = options[:port].to_s if options.has?(:port)
        params['AvailabilityZone'] = options[:availability_zone] if options.has?(:availability_zone)

        return response_generator(:action => "RestoreDBInstanceToPointInTime", :params => params)
      end

      # This API method authorizes network ingress for an amazon ec2 group
      #
      # @option options [String] :db_security_group_name is the name of the db security group
      # @option options [String] :cidrip is the network ip to revoke
      # @option options [String] :ec2_security_group_name is the name of the ec2 security group to authorize
      # @option options [String] :ec2_security_group_owner_id is the owner id of the security group
      #
      def revoke_db_security_group( options = {} )
        raise ArgumentError, "No :db_security_group_name provided" if options.does_not_have?(:db_security_group_name)

        params = {}
        params['DBSecurityGroupName'] = options[:db_security_group_name]

        if options.has?(:cidrip)
          params['CIDRIP'] = options[:cidrip]
        elsif options.has?(:ec2_security_group_name) && options.has?(:ec2_security_group_owner_id)
          params['EC2SecurityGroupName'] = options[:ec2_security_group_name]
          params['EC2SecurityGroupOwnerId'] = options[:ec2_security_group_owner_id]
        else
          raise ArgumentError, "No :cidrip or :ec2_security_group_name and :ec2_security_group_owner_id provided"
        end

        return response_generator(:action => "RevokeDBSecurityGroupIngress", :params => params)
      end

    end
  end
end

