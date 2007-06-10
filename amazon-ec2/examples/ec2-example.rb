#!/usr/bin/env ruby

require 'rubygems'
require File.dirname(__FILE__) + '/../lib/EC2'

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

ec2 = EC2::AWSAuthConnection.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY )

puts "----- GEM Version -----"
puts EC2::VERSION::STRING

puts "----- ec2.methods.sort -----"
p ec2.methods.sort

puts "----- listing images owned by 'amazon' -----"
ec2.describe_images(:owner_id => "amazon").each do |image|
  image.members.each do |member|
    puts "#{member} => #{image[member]}" 
  end
end

puts "----- listing all running instances -----"
puts ec2.describe_instances()

puts "----- creating a security group -----"
puts ec2.create_security_group(:group_name => "ec2-example-rb-test-group", :group_description => "ec-example.rb test group description.")

puts "----- listing security groups -----"
puts ec2.describe_security_groups()

puts "----- deleting a security group -----"
puts ec2.delete_security_group(:group_name => "ec2-example-rb-test-group")

puts "----- listing my keypairs (verbose mode) -----"
puts ec2.describe_keypairs()

