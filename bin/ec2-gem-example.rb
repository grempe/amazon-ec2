#!/usr/bin/env ruby

# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/../lib/AWS'
require 'pp'

# pull these from the local shell environment variables set in ~/.bash_login
# or using appropriate methods specific to your login shell.
#
# e.g. in ~/.bash_login
#
#  # For amazon-ec2 and amazon s3 ruby gems
#  export AMAZON_ACCESS_KEY_ID="FOO"
#  export AMAZON_SECRET_ACCESS_KEY="BAR"

ACCESS_KEY_ID = ENV['AMAZON_ACCESS_KEY_ID']
SECRET_ACCESS_KEY = ENV['AMAZON_SECRET_ACCESS_KEY']

if ACCESS_KEY_ID.nil? || ACCESS_KEY_ID.empty?
  puts "Error : You must add the shell environment variables AMAZON_ACCESS_KEY_ID and AMAZON_SECRET_ACCESS_KEY before calling #{$0}!"
  exit
end

# us-east-1.ec2.amazonaws.com == ec2.amazonaws.com
# eu-west-1.ec2.amazonaws.com for the european region
# test different servers by running something like:
# export EC2_URL='https://ec2.amazonaws.com';./bin/ec2-gem-example.rb
if ENV['EC2_URL']
  ec2 = AWS::EC2::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY, :server => URI.parse(ENV['EC2_URL']).host )
else
  # default server is US ec2.amazonaws.com
  ec2 = AWS::EC2::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY )
end

puts "----- ec2.methods.sort -----"
p ec2.methods.sort

puts "----- listing images owned by 'amazon' -----"
ec2.describe_images(:owner_id => "amazon").imagesSet.item.each do |image|
  image.keys.each do |key|
    puts "#{key} => #{image[key]}"
  end
end

puts "----- listing all running instances -----"
pp ec2.describe_instances()

puts "----- creating a security group -----"
pp ec2.create_security_group(:group_name => "ec2-example-rb-test-group", :group_description => "ec-example.rb test group description.")

puts "----- listing security groups -----"
pp ec2.describe_security_groups()

puts "----- deleting a security group -----"
pp ec2.delete_security_group(:group_name => "ec2-example-rb-test-group")

puts "----- listing my keypairs (verbose mode) -----"
pp ec2.describe_keypairs()

# ELB examples
# Autoscaling examples
if ENV['ELB_URL']
  elb = AWS::ELB::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY, :server => URI.parse(ENV['ELB_URL']).host )
else
  elb = AWS::ELB::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
end

puts "----- creating an elastic load balancer -----"
pp elb.create_load_balancer(  
                            :availability_zones => ["us-east-1a"],
                            :load_balancer_name => "elb-test-load-balancer",
                            :listeners => [{:protocol => "tcp", :load_balancer_port => "80", :instance_port => "8080"}]
                           )

puts "----- listing elastic load balancers -----"
pp elb.describe_load_balancers(:load_balancer_names => ["elb-test-load-balancer"])

puts "----- deleting load balancer -----"
pp elb.delete_load_balancer(:load_balancer_name => "elb-test-load-balancer")

# Autoscaling examples
if ENV['AS_URL']
  as = AWS::Autoscaling::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY, :server => URI.parse(ENV['AS_URL']).host )
else
  as = AWS::Autoscaling::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
end

puts "---- creating a launch configuration group -----"
pp as.create_launch_configuration( 
                                :image_id => "ami-ed46a784", 
                                :instance_type => "m1.small",
                                :availability_zones => ["us-east-1a"],
                                :launch_configuration_name => "ec2-example-test-launch-configuration"
                              )
                              
puts "---- creating an autoscaling group -----"
pp as.create_autoscaling_group( :autoscaling_group_name => "ec2-example-test-autoscaling-group", 
                                :availability_zones => ["us-east-1a"],
                                :min_size => 0,
                                :max_size => 0,
                                :launch_configuration_name => "ec2-example-test-launch-configuration"
                              )
                              
puts "---- listing autoscaling groups -----"
pp as.describe_autoscaling_groups(:autoscaling_group_names => [])

puts "---- creating a new autoscaling trigger ----"
pp as.create_or_updated_scaling_trigger(
                                        :autoscaling_group_name => "ec2-example-test-autoscaling-group",
                                        :measure_name => "CPUUtilization",
                                        :statistic => "Average",
                                        :period => 300,
                                        :trigger_name => "test-auto-scaling-trigger-name",
                                        :lower_threshold => 0.2,
                                        :lower_breach_scale_increment => 0,
                                        :upper_threshold => 1.5,
                                        :upper_breach_scale_increment => 0,
                                        :breach_duration => 1200,
                                        :dimensions => ["AutoScalingGroupName", "ec2-example-test-autoscaling-group"]
                                       )

puts "---- deleting scaling trigger -----"
pp as.delete_trigger(:trigger_name => "test-auto-scaling-trigger-name", :autoscaling_group_name => "ec2-example-test-autoscaling-group")

puts "---- deleting autoscaling group -----"
pp as.delete_autoscaling_group(:autoscaling_group_name => "ec2-example-test-autoscaling-group")

puts "---- deleting launch configuration group -----"
pp as.delete_launch_configuration(:launch_configuration_name => "ec2-example-test-launch-configuration")