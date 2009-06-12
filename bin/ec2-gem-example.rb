#!/usr/bin/env ruby

# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/../lib/EC2'
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
  ec2 = EC2::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY, :server => URI.parse(ENV['EC2_URL']).host )
else
  # default server is US ec2.amazonaws.com
  ec2 = EC2::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY )
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
