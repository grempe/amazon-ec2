#!/usr/bin/env ruby

# Basic single command application that we can call with perftools.rb to get consistent results.

require File.dirname(__FILE__) + '/../lib/AWS'
ACCESS_KEY_ID = ENV['AMAZON_ACCESS_KEY_ID']
SECRET_ACCESS_KEY = ENV['AMAZON_SECRET_ACCESS_KEY']
ec2 = AWS::EC2::Base.new( :access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY )
@images = ec2.describe_images

