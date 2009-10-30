require File.dirname(__FILE__) + '/test_helper.rb'

context "rds databases " do
  before do
    @rds = AWS::RDS::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @create_db_instance_body = <<-RESPONSE
    <CreateDBInstanceResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <CreateDBInstanceResult>
        <DBInstance>
          <Engine>MySQL5.1</Engine>
          <BackupRetentionPeriod>1</BackupRetentionPeriod>
          <DBInstanceStatus>creating</DBInstanceStatus>
          <DBInstanceIdentifier>mydbinstance</DBInstanceIdentifier>
          <PreferredBackupWindow>03:00-05:00</PreferredBackupWindow>
          <DBSecurityGroups>
            <DBSecurityGroup>
              <Status>active</Status>
              <DBSecurityGroupName>default</DBSecurityGroupName>
            </DBSecurityGroup>
          </DBSecurityGroups>
          <PreferredMaintenanceWindow>sun:05:00-sun:09:00</PreferredMaintenanceWindow>
          <AllocatedStorage>10</AllocatedStorage>
          <DBInstanceClass>db.m1.large</DBInstanceClass>
          <MasterUsername>master</MasterUsername>
        </DBInstance>
      </CreateDBInstanceResult>
      <ResponseMetadata>
        <RequestId>e6fb58c5-bf34-11de-b88d-993294bf1c81</RequestId>
      </ResponseMetadata>
    </CreateDBInstanceResponse>
    RESPONSE
    @create_db_security_group = <<-RESPONSE
    <CreateDBSecurityGroupResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <CreateDBSecurityGroupResult>
        <DBSecurityGroup>
          <EC2SecurityGroups/>
          <DBSecurityGroupDescription>My new DBSecurityGroup</DBSecurityGroupDescription>
          <IPRanges/>
          <OwnerId>621567473609</OwnerId>
          <DBSecurityGroupName>mydbsecuritygroup4</DBSecurityGroupName>
        </DBSecurityGroup>
      </CreateDBSecurityGroupResult>
      <ResponseMetadata>
        <RequestId>c9cf9ff2-bf36-11de-b88d-993294bf1c81</RequestId>
      </ResponseMetadata>
    </CreateDBSecurityGroupResponse>
    RESPONSE
  end

  specify "should be able to be create a db_instance" do
    @rds.stubs(:make_request).with('CreateDBInstance', {'Engine' => 'MySQL5.1',
        'MasterUsername' => 'master',
        'DBInstanceClass' => 'db.m1.large',
        'DBInstanceIdentifier' => 'testdb',
        'AllocatedStorage' => '10',
        'MasterUserPassword' => 'SecretPassword01'}).
      returns stub(:body => @create_db_instance_body, :is_a? => true)
    response = @rds.create_db_instance(
      :db_instance_class => "db.m1.large",
      :db_instance_identifier=>"testdb",
      :allocated_storage => 10,
      :engine => "MySQL5.1",
      :master_user_password => "SecretPassword01",
      :master_username => "master"
      )
    response.should.be.an.instance_of Hash

    assert_equal response.CreateDBInstanceResult.DBInstance.AllocatedStorage, "10"
  end

  specify "should be able to create_db_security_group" do
    @rds.stubs(:make_request).with('CreateDBSecurityGroup', {
                      'DBSecurityGroupName' => 'mydbsecuritygroup',
                      'DBSecurityGroupDescription' => 'My new DBSecurityGroup'}).
      returns stub(:body => @create_db_security_group, :is_a? => true)
    response = @rds.create_db_security_group(
        :db_security_group_name => "mydbsecuritygroup",
        :db_security_group_description => "My new DBSecurityGroup"
      )
    response.should.be.an.instance_of Hash

    assert_equal response.CreateDBSecurityGroupResult.DBSecurityGroup.DBSecurityGroupName, "mydbsecuritygroup4"
  end

  specify "should be able to create_db_parameter_group" do
    body =<<-EOE
    <CreateDBParameterGroupResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <CreateDBParameterGroupResult>
        <DBParameterGroup>
          <Engine>mysql5.1</Engine>
          <Description>My new DBParameterGroup</Description>
          <DBParameterGroupName>mydbparametergroup3</DBParameterGroupName>
        </DBParameterGroup>
      </CreateDBParameterGroupResult>
      <ResponseMetadata>
        <RequestId>0b447b66-bf36-11de-a88b-7b5b3d23b3a7</RequestId>
      </ResponseMetadata>
    </CreateDBParameterGroupResponse>
    EOE
    @rds.stubs(:make_request).with('CreateDBParameterGroup', {'Engine' => 'MySQL5.1',
                                                  'DBParameterGroupName' => 'mydbsecuritygroup',
                                                  'Description' => 'My test DBSecurity group'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.create_db_parameter_group(
        :db_parameter_group_name => "mydbsecuritygroup",
        :description => "My test DBSecurity group",
        :engine => "MySQL5.1"
      )
    response.should.be.an.instance_of Hash

    assert_equal response.CreateDBParameterGroupResult.DBParameterGroup.DBParameterGroupName, "mydbparametergroup3"
  end

  specify "should be able to create_db_snapshot" do
    body =<<-EOE
    <CreateDBSnapshotResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <CreateDBSnapshotResult>
        <DBSnapshot>
          <Port>3306</Port>
          <Status>creating</Status>
          <Engine>mysql5.1</Engine>
          <AvailabilityZone>us-east-1d</AvailabilityZone>
          <InstanceCreateTime>2009-10-21T04:05:43.609Z</InstanceCreateTime>
          <AllocatedStorage>50</AllocatedStorage>
          <DBInstanceIdentifier>mynewdbinstance</DBInstanceIdentifier>
          <MasterUsername>sa</MasterUsername>
          <DBSnapshotIdentifier>mynewdbsnapshot3</DBSnapshotIdentifier>
        </DBSnapshot>
      </CreateDBSnapshotResult>
      <ResponseMetadata>
        <RequestId>48e870fd-bf38-11de-a88b-7b5b3d23b3a7</RequestId>
      </ResponseMetadata>
    </CreateDBSnapshotResponse>
    EOE
    @rds.stubs(:make_request).with('CreateDBSnapshot', {'DBSnapshotIdentifier' => 'mynewdbsnapshot3', 'DBInstanceIdentifier' => 'mynewdbinstance'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.create_db_snapshot(
        :db_snapshot_identifier => "mynewdbsnapshot3",
        :db_instance_identifier => "mynewdbinstance"
      )
    response.should.be.an.instance_of Hash

    assert_equal response.CreateDBSnapshotResult.DBSnapshot.DBSnapshotIdentifier, "mynewdbsnapshot3"
  end

  specify "should be able to authorize_db_security_group" do
    body =<<-EOE
    <AuthorizeDBSecurityGroupIngressResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <AuthorizeDBSecurityGroupIngressResult>
        <DBSecurityGroup>
          <EC2SecurityGroups/>
          <DBSecurityGroupDescription>My new DBSecurityGroup</DBSecurityGroupDescription>
          <IPRanges>
            <IPRange>
              <CIDRIP>192.168.1.1/24</CIDRIP>
              <Status>authorizing</Status>
            </IPRange>
          </IPRanges>
          <OwnerId>621567473609</OwnerId>
          <DBSecurityGroupName>mydbsecuritygroup</DBSecurityGroupName>
        </DBSecurityGroup>
      </AuthorizeDBSecurityGroupIngressResult>
      <ResponseMetadata>
        <RequestId>d9799197-bf2d-11de-b88d-993294bf1c81</RequestId>
      </ResponseMetadata>
    </AuthorizeDBSecurityGroupIngressResponse>
    EOE
    @rds.stubs(:make_request).with('AuthorizeDBSecurityGroupIngress', {'CIDRIP' => '192.168.1.1/24', 'DBSecurityGroupName' => 'mydbsecuritygroup'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.authorize_db_security_group(
        :db_security_group_name => "mydbsecuritygroup",
        :cidrip => "192.168.1.1/24"
      )
    response.should.be.an.instance_of Hash

    assert_equal response.AuthorizeDBSecurityGroupIngressResult.DBSecurityGroup.IPRanges.IPRange.CIDRIP, "192.168.1.1/24"
  end

  specify "should be able to delete_db_parameter_group" do
    body =<<-EOE
    <DeleteDBParameterGroupResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <ResponseMetadata>
        <RequestId>4dc38be9-bf3b-11de-a88b-7b5b3d23b3a7</RequestId>
      </ResponseMetadata>
    </DeleteDBParameterGroupResponse>
    EOE
    @rds.stubs(:make_request).with('DeleteDBParameterGroup', {'DBParameterGroupName' => 'mydbsecuritygroup'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.delete_db_parameter_group(
        :db_parameter_group_name => "mydbsecuritygroup"
      )
    response.should.be.an.instance_of Hash
  end

  specify "should be able to delete_db_security_group" do
    body =<<-EOE
    <DeleteDBParameterGroupResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <ResponseMetadata>
        <RequestId>4dc38be9-bf3b-11de-a88b-7b5b3d23b3a7</RequestId>
      </ResponseMetadata>
    </DeleteDBParameterGroupResponse>
    EOE
    @rds.stubs(:make_request).with('DeleteDBSecurityGroup', {'DBSecurityGroupName' => 'mydbsecuritygroup'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.delete_db_security_group(
        :db_security_group_name => "mydbsecuritygroup"
      )
    response.should.be.an.instance_of Hash
  end

  specify "should be able to delete_db_snapshot" do
    body =<<-EOE
    <DeleteDBParameterGroupResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <ResponseMetadata>
        <RequestId>4dc38be9-bf3b-11de-a88b-7b5b3d23b3a7</RequestId>
      </ResponseMetadata>
    </DeleteDBParameterGroupResponse>
    EOE
    @rds.stubs(:make_request).with('DeleteDBSnapshot', {'DBSnapshotIdentifier' => 'snapshotname'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.delete_db_snapshot(
        :db_snapshot_identifier => "snapshotname"
      )
    response.should.be.an.instance_of Hash
  end

  specify "should be able to describe_db_instances" do
    body =<<-EOE
    <DescribeDBInstancesResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <DescribeDBInstancesResult>
        <DBInstances>
          <DBInstance>
            <LatestRestorableTime>2009-10-22T18:59:59Z</LatestRestorableTime>
            <Engine>mysql5.1</Engine>
            <BackupRetentionPeriod>3</BackupRetentionPeriod>
            <DBInstanceStatus>available</DBInstanceStatus>
            <DBParameterGroups>
              <DBParameterGroup>
                <ParameterApplyStatus>pending-reboot</ParameterApplyStatus>
                <DBParameterGroupName>default.mysql5.1</DBParameterGroupName>
              </DBParameterGroup>
            </DBParameterGroups>
            <Endpoint>
              <Port>8443</Port>
              <Address>dbinstancename.clouwupjnvmq.us-east-1-devo.rds.amazonaws.com</Address>
            </Endpoint>
            <DBInstanceIdentifier>dbinstancename</DBInstanceIdentifier>
            <PreferredBackupWindow>03:00-05:00</PreferredBackupWindow>
            <DBSecurityGroups>
              <DBSecurityGroup>
                <Status>active</Status>
                <DBSecurityGroupName>default</DBSecurityGroupName>
              </DBSecurityGroup>
            </DBSecurityGroups>
            <DBName>testdb</DBName>
            <PreferredMaintenanceWindow>sun:05:00-sun:09:00</PreferredMaintenanceWindow>
            <AvailabilityZone>us-east-1a</AvailabilityZone>
            <InstanceCreateTime>2009-09-11T00:50:45.523Z</InstanceCreateTime>
            <AllocatedStorage>20</AllocatedStorage>
            <DBInstanceClass>db.m1.xlarge</DBInstanceClass>
            <MasterUsername>sa</MasterUsername>
          </DBInstance>
        </DBInstances>
      </DescribeDBInstancesResult>
      <ResponseMetadata>
        <RequestId>4f1fae46-bf3d-11de-a88b-7b5b3d23b3a7</RequestId>
      </ResponseMetadata>
    </DescribeDBInstancesResponse>
    EOE
    @rds.stubs(:make_request).with('DescribeDBInstances', {'MaxRecords' => '100'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.describe_db_instances(
        :max_records => "100"
      )
    response.should.be.an.instance_of Hash
  end

  specify "should be able to describe_db_instances" do
    body =<<-EOE
    <DescribeEngineDefaultParametersResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <DescribeEngineDefaultParametersResult>
        <EngineDefaults>
          <Engine>mysql5.1</Engine>
          <Marker>bWF4X3VzZXJfY29ubmVjdGlvbnM=</Marker>
          <Parameters>
            <Parameter>
              <DataType>boolean</DataType>
              <Source>engine-default</Source>
              <IsModifiable>true</IsModifiable>
              <Description>Controls whether user-defined functions that have only an xxx symbol for the main function can be loaded</Description>
              <ApplyType>static</ApplyType>
              <AllowedValues>ON,OFF</AllowedValues>
              <ParameterName>allow-suspicious-udfs</ParameterName>
            </Parameter>
            <Parameter>
              <DataType>integer</DataType>
              <Source>engine-default</Source>
              <IsModifiable>true</IsModifiable>
              <Description>Intended for use with master-to-master replication, and can be used to control the operation of AUTO_INCREMENT columns</Description>
              <ApplyType>dynamic</ApplyType>
              <AllowedValues>1-65535</AllowedValues>
              <ParameterName>auto_increment_increment</ParameterName>
            </Parameter>
          </Parameters>
        </EngineDefaults>
      </DescribeEngineDefaultParametersResult>
      <ResponseMetadata>
        <RequestId>811f4032-bf3e-11de-b88d-993294bf1c81</RequestId>
      </ResponseMetadata>
    </DescribeEngineDefaultParametersResponse>
    EOE
    @rds.stubs(:make_request).with('DescribeEngineDefaultParameters', {'Engine' => 'MySQL5.1'}).
      returns stub(:body => body, :is_a? => true)
    response = @rds.describe_engine_default_parameters(
        :engine => "MySQL5.1"
      )
    response.should.be.an.instance_of Hash
  end

  specify "should be able to describe_db_instances" do
    body =<<-EOE
    <ModifyDBParameterGroupResponse xmlns="http://rds.amazonaws.com/admin/2009-10-16/">
      <ModifyDBParameterGroupResult>
        <DBParameterGroupName>mydbparametergroup</DBParameterGroupName>
      </ModifyDBParameterGroupResult>
      <ResponseMetadata>
        <RequestId>5ba91f97-bf51-11de-bf60-ef2e377db6f3</RequestId>
      </ResponseMetadata>
    </ModifyDBParameterGroupResponse>
    EOE

    @rds.stubs(:make_request).with('ModifyDBParameterGroup', {
        'DBParameterGroupName' => 'mytestdb',
        'Parameters.member.1.ParameterName' => 'max_user_connections',
        'Parameters.member.1.ParameterValue' => '24',
        'Parameters.member.1.ApplyMethod' => 'pending-reboot',
        'Parameters.member.2.ParameterName' => 'max_allowed_packet',
        'Parameters.member.2.ParameterValue' => '1024',
        'Parameters.member.2.ApplyMethod' => 'immediate',
        }).
      returns stub(:body => body, :is_a? => true)
    response = @rds.modify_db_parameter_group(
        :db_parameter_group_name => "mytestdb",
        :parameters => [
          {:name => "max_user_connections", :value => "24", :apply_method => "pending-reboot"},
          {:name => "max_allowed_packet", :value => "1024", :apply_method => "immediate"}
        ]
      )
    response.should.be.an.instance_of Hash
  end

end

