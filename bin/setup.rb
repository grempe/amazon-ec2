#!/usr/bin/env ruby

# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

if ENV['AMAZON_ACCESS_KEY_ID'] && ENV['AMAZON_SECRET_ACCESS_KEY']
  opts = {
    :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
  }
  if ENV['EC2_URL']
    opts[:server] = URI.parse(ENV['EC2_URL']).host
  end
  @ec2 = AWS::EC2::Base.new(opts)
  @elb = AWS::ELB::Base.new(opts)
  @as = AWS::Autoscaling::Base.new(opts)
  @rds = AWS::RDS::Base.new(opts)
end

puts "EC2 Server: #{opts[:server]}"

include AWS

