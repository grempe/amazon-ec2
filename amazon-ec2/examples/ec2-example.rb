#!/usr/bin/env ruby

require 'rubygems'
require_gem 'amazon-ec2'

# EDIT ME : Fill with YOUR AWS Access Key ID & Secret Access Key
AWS_ACCESS_KEY_ID = ""
AWS_SECRET_ACCESS_KEY = ""

if AWS_ACCESS_KEY_ID.nil? || AWS_ACCESS_KEY_ID.empty?
  puts "You must edit #{$0} and add your AWS credentials before use!"
  exit
end

SECURITY_GROUP_NAME = "ec2-example-rb-test-group"

ec2 = EC2::AWSAuthConnection.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

puts "----- GEM Version -----"
puts EC2::VERSION::STRING

puts "----- ec2.methods.sort -----"
p ec2.methods.sort

puts "----- listing images -----"
ec2.describe_images.each do |image|
  image.members.each do |member|
    puts "#{member} => #{image[member]}" 
  end
end

puts "----- listing instances -----"
puts ec2.describe_instances()

puts "----- creating a security group -----"
puts ec2.create_securitygroup(SECURITY_GROUP_NAME, "ec-example.rb test group")

puts "----- listing security groups -----"
puts ec2.describe_securitygroups()

puts "----- deleting a security group -----"
puts ec2.delete_securitygroup(SECURITY_GROUP_NAME)

puts "----- listing keypairs (verbose mode) -----"
puts ec2.describe_keypairs()

