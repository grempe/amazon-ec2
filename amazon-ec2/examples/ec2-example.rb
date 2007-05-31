#!/usr/bin/env ruby

#  This software code is made available "AS IS" without warranties of any
#  kind.  You may copy, display, modify and redistribute the software
#  code either by itself or as incorporated into your code; provided that
#  you do not remove any proprietary notices.  Your use of this software
#  code is at your own risk and you waive any claim against Amazon Web
#  Services LLC or its affiliates with respect to your use of this software
#  code. (c) 2006 Amazon Web Services LLC or its affiliates.  All rights
#  reserved.

require 'rubygems'
require_gem 'amazon-ec2'

AWS_ACCESS_KEY_ID = '--YOUR AWS ACCESS KEY ID--'
AWS_SECRET_ACCESS_KEY = '--YOUR AWS SECRET ACCESS KEY--'

# remove these next two lines as well, when you've updated your credentials.
puts "update #{$0} with your AWS credentials"
exit

SECURITY_GROUP_NAME = "ec2-example-rb-test-group"

conn = EC2::AWSAuthConnection.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

puts "----- GEM Version -----"
puts EC2::VERSION::STRING

puts "----- listing images -----"
puts conn.describe_images()

puts "----- listing instances -----"
puts conn.describe_instances()

puts "----- creating a security group -----"
puts conn.create_securitygroup(SECURITY_GROUP_NAME, "ec-example.rb test group")

puts "----- listing security groups -----"
puts conn.describe_securitygroups()

puts "----- deleting a security group -----"
puts conn.delete_securitygroup(SECURITY_GROUP_NAME)

puts "----- listing keypairs (verbose mode) -----"
conn.verbose = true
puts conn.describe_keypairs()


