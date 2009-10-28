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
      # @option options [String] :db_security_groups are the list of db security groups to associate with the instance (nil)
      # @option options [String] :availability_zone is the availability_zone to create the instance in (nil)
      # @option options [String] :preferred_maintenance_window in format: ddd:hh24:mi-ddd:hh24:mi (nil)
      # @option options [String] :backend_retention_period is the number of days which automated backups are retained (1)
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
        params["DBSecurityGroups"] = options[:db_security_groups] if options.has?(:db_security_groups)
        params["AvailabilityZone"] = options[:availability_zone] if options.has?(:availability_zone)
        params["PreferredMaintenanceWindow"] = options[:preferred_backup_window] if options.has?(:preferred_backup_window)
        params["BackupRetentionPeriod"] = options[:backend_retention_period] if options.has?(:backend_retention_period)
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
        params["FinalDBSnapshot­Identifier"] = options[:final_db_snapshot_identifier].to_s if options.has?(:final_db_snapshot_identifier)
        
        return response_generator(:action => "DeleteDBInstance", :params => params)
      end
      
    end
  end
end