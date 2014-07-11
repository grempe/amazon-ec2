#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "CloudWatch monitoring" do
  
  before do
    @cw = AWS::Cloudwatch::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @success_response = <<-XML
    <PutMetricDataResponse xmlns="http://monitoring.amazonaws.com/doc/2010-08-01/">
      <ResponseMetadata>
        <RequestId>e16fc4d3-9a04-11e0-9362-093a1cae5385</RequestId>
      </ResponseMetadata>
    </PutMetricDataResponse>
    XML

    @now = Time.now
    
    @simple_request = {
      'Namespace' => 'App/Metrics',
      'MetricData.member.1.MetricName' => 'FooBar',
      'MetricData.member.1.Unit' => 'Count',
      'MetricData.member.1.Value' => '56265313',
      'MetricData.member.1.Timestamp' => Time.now.iso8601,
    }
    @more_complex_request = {
      'Namespace' => 'App/Metrics',
      'MetricData.member.1.MetricName' => 'FooBar',
      'MetricData.member.1.Unit' => 'Count',
      'MetricData.member.1.Value' => '56265313',
      'MetricData.member.1.Timestamp' => Time.now.iso8601,
      'Namespace' => 'App/Metrics',
      'MetricData.member.2.MetricName' => 'FooBar',
      'MetricData.member.2.Unit' => 'Count',
      'MetricData.member.2.Value' => '56265313',
      'MetricData.member.2.Timestamp' => Time.now.-(60).iso8601,
      'Namespace' => 'App/Metrics',
      'MetricData.member.3.MetricName' => 'FooBar',
      'MetricData.member.3.Unit' => 'Count',
      'MetricData.member.3.Value' => '56265313',
      'MetricData.member.3.Timestamp' => Time.now.-(120).iso8601,
      'Namespace' => 'App/Metrics',
      'MetricData.member.4.MetricName' => 'FooBar',
      'MetricData.member.4.Unit' => 'Count',
      'MetricData.member.4.Value' => '56265313',
      'MetricData.member.4.Timestamp' => Time.now.-(180).iso8601,
      'Namespace' => 'App/Metrics',
      'MetricData.member.5.MetricName' => 'FooBar',
      'MetricData.member.5.Unit' => 'Count',
      'MetricData.member.5.Value' => '56265313',
      'MetricData.member.5.Timestamp' => Time.now.-(240).iso8601,
    }
    @most_complex_request = {
      'Namespace' => 'App/Metrics',
      'MetricData.member.1.MetricName' => 'FooBar',
      'MetricData.member.1.Unit' => 'Count',
      'MetricData.member.1.Value' => '56265313',
      'MetricData.member.1.Timestamp' => Time.now.iso8601,
      'MetricData.member.1.Dimensions.member.1.Name' => 'InstanceID',
      'MetricData.member.1.Dimensions.member.1.Value' => 'i-12345678',
      'Namespace' => 'App/Metrics',
      'MetricData.member.2.MetricName' => 'FooBar',
      'MetricData.member.2.Unit' => 'Count',
      'MetricData.member.2.Value' => '56265313',
      'MetricData.member.2.Timestamp' => Time.now.-(60).iso8601,
      'MetricData.member.2.Dimensions.member.1.Name' => 'InstanceID',
      'MetricData.member.2.Dimensions.member.1.Value' => 'i-12345678',
      'Namespace' => 'App/Metrics',
      'MetricData.member.3.MetricName' => 'FooBar',
      'MetricData.member.3.Unit' => 'Count',
      'MetricData.member.3.Value' => '43',
      'MetricData.member.3.Timestamp' => Time.now.-(120).iso8601,
      'MetricData.member.3.Dimensions.member.1.Name' => 'InstanceID',
      'MetricData.member.3.Dimensions.member.1.Value' => 'i-12345678',
    }
  end

  specify "should put a single point without nested hashes" do
    @cw.stubs(:make_request).with('PutMetricData', @simple_request).
      returns(:body => @success_response, :is_a => true)
    @cw.put_metric_data({
      :namespace => 'App/Metrics',
      :metric_name => 'FooBar',
      :unit => 'Count',
      :value => 56265313
    }).should.be.an.instance_of Hash
  end

  specify "should put several metric data points with in an array" do
    @cw.stubs(:make_request).with('PutMetricData', @more_complex_request).
      returns(:body => @success_response, :is_a => true)
    @cw.put_metric_data({
      :namespace => 'App/Metrics',
      :metric_data => [
        {:metric_name => 'FooBar', :unit => 'Count', :value => 56265313, :timestamp => @now},
        {:metric_name => 'FooBar', :unit => 'Count', :value => 56265313, :timestamp => @now -  60},
        {:metric_name => 'FooBar', :unit => 'Count', :value => 56265313, :timestamp => @now - 120},
        {:metric_name => 'FooBar', :unit => 'Count', :value => 56265313, :timestamp => @now - 180},
        {:metric_name => 'FooBar', :unit => 'Count', :value => 56265313, :timestamp => @now - 240}
      ]
    }).should.be.an.instance_of Hash
  end

  specify "should allow the user to be DRY" do
    @cw.stubs(:make_request).with('PutMetricData', @most_complex_request).
      returns(:body => @success_response, :is_a => true)
    @cw.put_metric_data({
      :namespace => 'App/Metrics',
      :metric_name => 'FooBar',
      :unit => 'Count',
      :dimensions => {'InstanceID' => 'i-12345678'}, # It can accept more dimensions,
                                                     # but their order is unpredictable
      :value => 56265313,
      :metric_data => [
        {:timestamp => @now},
        {:timestamp => @now - 60},
        {:timestamp => @now - 120, :value => 43} # This was the odd one out
      ]
    }).should.be.an.instance_of Hash
  end

  specify "should not allow bad arguments" do
    lambda {@cw.put_metric_data()}.should.raise(AWS::ArgumentError)
    lambda {@cw.put_metric_data({:namespace => 'TEST', :metric_name => 'FooBar', :unit => 'Click'})}.should.raise(AWS::ArgumentError)
    lambda {@cw.put_metric_data({:metric_name => 'FooBar', :unit => 'Click', :value => 23})}.should.raise(AWS::ArgumentError)
    lambda {@cw.put_metric_data({:namespace => 'TEST', :unit => 'Click', :value => 23})}.should.raise(AWS::ArgumentError)
  end

end
