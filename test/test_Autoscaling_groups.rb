require File.dirname(__FILE__) + '/test_helper.rb'

context "autoscaling " do
  before do
    @as = AWS::Autoscaling::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @valid_create_launch_configuration_params = {
      :image_id => "ami-ed46a784",
      :launch_configuration_name => "TestAutoscalingGroupName",
      :instance_type => "m1.small"
    }

    @error_response_for_creation = <<-RESPONSE
<ErrorResponse xmlns="http://autoscaling.amazonaws.com/doc/2009-05-15/">
  <Error>
    <Type>Sender</Type>
    <Code>AlreadyExists</Code>
    <Message>Launch Configuration by this name already exists - A launch configuration already exists with the name TestAutoscalingGroupName</Message>
  </Error>
  <RequestId>31d00b03-ad6a-11de-a47f-a5c562feca13</RequestId>
</ErrorResponse>
    RESPONSE

    @delete_launch_configuration_response = <<-RESPONSE
  <DeleteLaunchConfigurationResponse xmlns="http://autoscaling.amazonaws.com/doc/2009-05-15/">
    <ResponseMetadata>
      <RequestId>5f5717d3-ad6c-11de-b1c0-1b00aadc5f72</RequestId>
    </ResponseMetadata>
  </DeleteLaunchConfigurationResponse>
    RESPONSE

    @create_launch_configuration_response = "<CreateLaunchConfigurationResponse xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">\n  <ResponseMetadata>\n    <RequestId>6062466f-ad6c-11de-b82f-996c936914c5</RequestId>\n  </ResponseMetadata>\n</CreateLaunchConfigurationResponse>\n"

    @create_autoscaling_group_response = "<CreateAutoScalingGroupResponse xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">\n  <ResponseMetadata>\n    <RequestId>cc4f9960-ad6e-11de-b82f-996c936914c5</RequestId>\n  </ResponseMetadata>\n</CreateAutoScalingGroupResponse>\n"

    @delete_autoscaling_group = "<DeleteAutoScalingGroupResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
<ResponseMetadata><RequestId>e64fc4c3-e10b-11dd-a73e-2d774d6aee71</RequestId></ResponseMetadata></DeleteAutoScalingGroupResponse>"
    @create_or_update_trigger_response = "<CreateOrUpdateScalingTriggerResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
      <ResponseMetadata>
        <RequestId>503d309d-e10b-11dd-a73e-2d774d6aee71</RequestId>
      </ResponseMetadata>
    </CreateOrUpdateScalingTriggerResponse>"
  end

  specify "AWS::Autoscaling::Base should give back a nice response if there is an error" do
    @as.stubs(:make_request).with('CreateLaunchConfiguration', {
      'ImageId' => 'ami-ed46a784',
      'LaunchConfigurationName' => 'TestAutoscalingGroupName',
      'InstanceType' => "m1.small"
    }).returns stub(:body => @error_response_for_creation, :is_a? => true)

    response = @as.create_launch_configuration( :image_id => "ami-ed46a784", :launch_configuration_name => "TestAutoscalingGroupName", :instance_type => "m1.small")
    response.should.be.an.instance_of Hash
    response["Error"]["Message"].should.equal "Launch Configuration by this name already exists - A launch configuration already exists with the name TestAutoscalingGroupName"
  end

  specify "AWS::Autoscaling::Base should destroy a launch configuration just fine" do
    @as.stubs(:make_request).with('DeleteLaunchConfiguration', {
      'LaunchConfigurationName' => 'TestAutoscalingGroupName1'
    }).returns stub(:body => @delete_launch_configuration_response, :is_a? => true)

    response = @as.delete_launch_configuration( :launch_configuration_name => "TestAutoscalingGroupName1" )
    response.should.be.an.instance_of Hash
  end

  specify "AWS::Autoscaling::Base should create a launch configuration" do
    @as.stubs(:make_request).with('CreateLaunchConfiguration', {
      'ImageId' => 'ami-ed46a784',
      'LaunchConfigurationName' => 'CustomTestAutoscalingGroupName',
      'InstanceType' => "m1.small"
    }).returns stub(:body => @create_launch_configuration_response, :is_a? => true)

    response = @as.create_launch_configuration( :image_id => "ami-ed46a784", :launch_configuration_name => "CustomTestAutoscalingGroupName", :instance_type => "m1.small")
    response.should.be.an.instance_of Hash
  end

  specify "AWS::Autoscaling::Base should be able to create a new autoscaling group" do
    @as.stubs(:make_request).with("CreateAutoScalingGroup", {
      'AutoScalingGroupName' => 'CloudteamTestAutoscalingGroup1',
      'AvailabilityZones.member.1' => 'us-east-1a',
      'LoadBalancerNames.member.1' => 'TestLoadBalancerName',
      'LoadBalancerNames.member.2' => 'TestLoadBalancerName2',
      'LaunchConfigurationName' => 'CloudteamTestAutoscaling',
      'MinSize' => "1", 'MaxSize' => "3", 'Cooldown' => 300
    }).returns stub(:body => @create_autoscaling_group_response, :is_a? => true)
    response = @as.create_autoscaling_group(:autoscaling_group_name => "CloudteamTestAutoscalingGroup1", :availability_zones => "us-east-1a", :load_balancer_names => ["TestLoadBalancerName", "TestLoadBalancerName2"], :launch_configuration_name => "CloudteamTestAutoscaling", :min_size => 1, :max_size => 3, :cooldown => 300)
    response.should.be.an.instance_of Hash
  end

  specify "AWS::Autoscaling::Base should destroy an autoscaling group" do
    @as.stubs(:make_request).with('DeleteAutoScalingGroup', {
      'AutoScalingGroupName' => 'TestAutoscalingGroupName1'
    }).returns stub(:body => @delete_autoscaling_group, :is_a? => true)

    response = @as.delete_autoscaling_group( :autoscaling_group_name => "TestAutoscalingGroupName1" )
    response.should.be.an.instance_of Hash
  end

  specify "AWS::Autoscaling::Base should be able to create a new scaling trigger" do
    @as.stubs(:make_request).with("CreateOrUpdateScalingTrigger", {
      'AutoScalingGroupName' => 'AutoScalingGroupName',
      'Unit' => "Seconds",
      'Dimensions.member.1.Name' => "AutoScalingGroupName",
      'Dimensions.member.1.Value' => "Bob",
      'MeasureName' => "CPUUtilization",
      'Statistic' => 'Average',
      'Period' => '120',
      'TriggerName' => "AFunNameForATrigger",
      'LowerThreshold' => "0.2",
      'LowerBreachScaleIncrement' => "-1",
      'UpperThreshold' => "1.5",
      'UpperBreachScaleIncrement' => "1",
      'BreachDuration' => "120",
      'Namespace' => "AWS/EC2",              
    }).returns stub(:body => @create_or_update_trigger_response, :is_a? => true)

    valid_create_or_update_scaling_trigger_params = {:autoscaling_group_name => "AutoScalingGroupName", :dimensions => {:name => "AutoScalingGroupName", :value => "Bob"}, :unit => "Seconds", :measure_name => "CPUUtilization", :namespace => "AWS/EC2", :statistic => "Average", :period => 120, :trigger_name => "AFunNameForATrigger", :lower_threshold => 0.2, :lower_breach_scale_increment => "-1", :upper_threshold => 1.5, :upper_breach_scale_increment => 1, :breach_duration => 120}

    %w(dimensions autoscaling_group_name measure_name statistic period trigger_name lower_threshold lower_breach_scale_increment upper_threshold upper_breach_scale_increment breach_duration).each do |meth_str|
      lambda { @as.create_or_updated_scaling_trigger(valid_create_or_update_scaling_trigger_params.merge(meth_str.to_sym=>nil)) }.should.raise(AWS::ArgumentError)
    end

    response = @as.create_or_updated_scaling_trigger(valid_create_or_update_scaling_trigger_params)
    response.should.be.an.instance_of Hash
  end

  specify "AWS::Autoscaling::Base should destroy a launch configuration group" do
    @as.stubs(:make_request).with('DeleteLaunchConfiguration', {
      'LaunchConfigurationName' => 'LaunchConfiguration'
    }).returns stub(:body => " <DeleteLaunchConfigurationResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
<ResponseMetadata><RequestId>e64fc4c3-e10b-11dd-a73e-2d774d6aee71</RequestId></ResponseMetadata>
</DeleteLaunchConfigurationResponse>", :is_a? => true)

    response = @as.delete_launch_configuration( :launch_configuration_name => "LaunchConfiguration" )
    response.should.be.an.instance_of Hash
  end

    specify "AWS::Autoscaling::Base should destroy a scaling trigger" do
      @as.stubs(:make_request).with('DeleteTrigger', {
        'TriggerName' => 'DeletingTrigger', 'AutoScalingGroupName' => "Name"
      }).returns stub(:body => "  <DeleteTriggerResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <ResponseMetadata>
            <RequestId>cca38097-e10b-11dd-a73e-2d774d6aee71</RequestId>
          </ResponseMetadata>
        </DeleteTriggerResponse>", :is_a? => true)

      response = @as.delete_trigger( :trigger_name => "DeletingTrigger", :autoscaling_group_name => "Name" )
      response.should.be.an.instance_of Hash
    end

    specify "AWS::Autoscaling::Base should describe the autoscaling groups" do
      @as.stubs(:make_request).with('DescribeAutoScalingGroups', {
        'AutoScalingGroupNames.member.1' => "webtier"
      }).returns stub(:body => "<DescribeAutoScalingGroupsResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <DescribeAutoScalingGroupsResult>
            <AutoScalingGroups>
              <member>
                <MinSize>0</MinSize>
                <CreatedTime>2009-01-13T00:38:54Z</CreatedTime>
                <AvailabilityZones>
        	         <member>us-east-1c</member>
                </AvailabilityZones>
                <Cooldown>0</Cooldown>
                <LaunchConfigurationName>wt20080929</LaunchConfigurationName>
                <AutoScalingGroupName>webtier</AutoScalingGroupName>
                <DesiredCapacity>1</DesiredCapacity>
                <Instances>
                  <member>
                    <InstanceId>i-8fa224e6</InstanceId>
                    <LifecycleState>InService</LifecycleState>
                    <AvailabilityZone>us-east-1c</AvailabilityZone>
                    </member>
                </Instances>
                <MaxSize>1</MaxSize>
              </member>
            </AutoScalingGroups>
          </DescribeAutoScalingGroupsResult>
          <ResponseMetadata>
            <RequestId>70f2e8af-e10b-11dd-a73e-2d774d6aee71</RequestId>
          </ResponseMetadata>
        </DescribeAutoScalingGroupsResponse>", :is_a? => true)

      response = @as.describe_autoscaling_groups( :autoscaling_group_names => ["webtier"] )
      response.should.be.an.instance_of Hash
    end

    specify "AWS::Autoscaling::Base should describe the launch configurations" do
      @as.stubs(:make_request).with('DescribeLaunchConfigurations', {
        'AutoScalingGroupNames.member.1' => "webtier"
      }).returns stub(:body => "<DescribeLaunchConfigurationsResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <DescribeLaunchConfigurationsResult>
            <LaunchConfigurations>
              <member>
                <InstanceType>m1.small</InstanceType>
                <BlockDeviceMappings/>
                <KeyName/>
                <SecurityGroups/>
                <ImageId>ami-f7c5219e</ImageId>
                <RamdiskId/>
                <CreatedTime>2009-01-13T00:35:31Z</CreatedTime>
                <KernelId/>
                <LaunchConfigurationName>wt20080929</LaunchConfigurationName>
                <UserData/>
              </member>
            </LaunchConfigurations>
          </DescribeLaunchConfigurationsResult>
          <ResponseMetadata>
            <RequestId>2e14cb6c-e10a-11dd-a73e-2d774d6aee71</RequestId>
          </ResponseMetadata>
        </DescribeLaunchConfigurationsResponse>", :is_a? => true)

      response = @as.describe_launch_configurations( :launch_configuration_names => ["webtier"] )
      response.should.be.an.instance_of Hash
    end


    specify "AWS::Autoscaling::Base should describe the launch configurations" do
      @as.stubs(:make_request).with('DescribeScalingActivities', {
        'AutoScalingGroupName' => "webtier"
      }).returns stub(:body => "<DescribeScalingActivitiesResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <DescribeScalingActivitiesResult>
            <Activities>
              <member>
                <ActivityId>885b2900-0f2e-497a-8ec6-b1b90a9ddee0</ActivityId>
                <StartTime>2009-03-29T04:07:07Z</StartTime>
                <Progress>0</Progress>
                <StatusCode>InProgress</StatusCode>
                <Cause>Automated Capacity Adjustment</Cause>
                <Description>Launching a new EC2 instance</Description>
              </member>
            </Activities>
          </DescribeScalingActivitiesResult>
          <ResponseMetadata>
            <RequestId>f0321780-e10a-11dd-a73e-2d774d6aee71</RequestId>
          </ResponseMetadata>
        </DescribeScalingActivitiesResponse>", :is_a? => true)

      response = @as.describe_scaling_activities( :autoscaling_group_name => "webtier" )
      response.should.be.an.instance_of Hash
    end

    specify "AWS::Autoscaling::Base should describe triggers" do
      @as.stubs(:make_request).with('DescribeTriggers', {
        'AutoScalingGroupName' => "webtier"
      }).returns stub(:body => "  <DescribeTriggersResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <DescribeTriggersResult>
            <Triggers>
              <member>
                <BreachDuration>300</BreachDuration>
                 <UpperBreachScaleIncrement>1</UpperBreachScaleIncrement>
                <CreatedTime>2009-01-13T00:44:19Z</CreatedTime>
                <UpperThreshold>60.0</UpperThreshold>
                <Status>NoData</Status>
                <LowerThreshold>0.0</LowerThreshold>
                <Period>60</Period>
                <LowerBreachScaleIncrement>-1</LowerBreachScaleIncrement>
                <TriggerName>tenpct</TriggerName>
                <Statistic>Average</Statistic>
                <Unit>None</Unit>
                <Namespace>AWS/EC2</Namespace>
                <Dimensions>

                  <member>
                    <Name>AutoScalingGroupName</Name>
                    <Value>webtier</Value>
                  </member>
                </Dimensions>
                <AutoScalingGroupName>webtier</AutoScalingGroupName>
                <MeasureName>CPUUtilization</MeasureName>
              </member>
            </Triggers>
          </DescribeTriggersResult>
          <ResponseMetadata>
            <RequestId>5c33c82a-e10b-11dd-a73e-2d774d6aee71</RequestId>
          </ResponseMetadata>
        </DescribeTriggersResponse>", :is_a? => true)

      response = @as.describe_triggers( :autoscaling_group_name => "webtier" )
      response.should.be.an.instance_of Hash
    end

    specify "AWS::Autoscaling::Base should describe triggers" do
      @as.stubs(:make_request).with('SetDesiredCapacity', {
        'AutoScalingGroupName' => "name", 'DesiredCapacity' => '10'
      }).returns stub(:body => "  <SetDesiredCapacityResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <ResponseMetadata>
            <RequestId>d3f2091c-e10a-11dd-a73e- 2d774d6aee71</RequestId>
          </ResponseMetadata>
        </SetDesiredCapacityResponse>
      ", :is_a? => true)

      response = @as.set_desired_capacity( :autoscaling_group_name => "name", :desired_capacity => "10" )
      response.should.be.an.instance_of Hash
    end


    specify "AWS::Autoscaling::Base should terminate an instance in an autoscaling group" do
      @as.stubs(:make_request).with('TerminateInstanceInAutoScalingGroup', {
        'InstanceId' => "i-instance1"
      }).returns stub(:body => "  <DescribeTriggersResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
          <DescribeTriggersResult>
            <Triggers>
              <member>
                <BreachDuration>300</BreachDuration>
                 <UpperBreachScaleIncrement>1</UpperBreachScaleIncrement>
                <CreatedTime>2009-01-13T00:44:19Z</CreatedTime>
                <UpperThreshold>60.0</UpperThreshold>
                <Status>NoData</Status>
                <LowerThreshold>0.0</LowerThreshold>
                <Period>60</Period>
                <LowerBreachScaleIncrement>-1</LowerBreachScaleIncrement>
                <TriggerName>tenpct</TriggerName>
                <Statistic>Average</Statistic>
                <Unit>None</Unit>
                <Namespace>AWS/EC2</Namespace>
                <Dimensions>

                  <member>
                    <Name>AutoScalingGroupName</Name>
                    <Value>webtier</Value>
                  </member>
                </Dimensions>
                <AutoScalingGroupName>webtier</AutoScalingGroupName>
                <MeasureName>CPUUtilization</MeasureName>
              </member>
            </Triggers>
          </DescribeTriggersResult>
          <ResponseMetadata>
            <RequestId>5c33c82a-e10b-11dd-a73e-2d774d6aee71</RequestId>
          </ResponseMetadata>
        </DescribeTriggersResponse>", :is_a? => true)

      response = @as.terminate_instance_in_autoscaling_group( :instance_id => "i-instance1" )
      response.should.be.an.instance_of Hash
    end


end
