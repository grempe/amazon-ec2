require File.dirname(__FILE__) + '/test_helper.rb'

context "elb load balancers " do
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
  end
  
  specify "should be able to be create a db_isntance" do
    @rds.stubs(:make_request).with('DeleteLoadBalancer', {'LoadBalancerName' => 'Test Name'}).
      returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)

  end
  
end