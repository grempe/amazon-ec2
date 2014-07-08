#!/usr/bin/env ruby

# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2010 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++



if(AWSAPI::ACCESS_KEY_ID and AWSAPI::SECRET_ACCESS_KEY)

  opts = {
    :access_key_id      => AWSAPI::ACCESS_KEY_ID,
    :secret_access_key  => AWSAPI::SECRET_ACCESS_KEY
  }

  if ENV['EC2_URL']
    ec2uri = URI.parse(ENV['EC2_URL'])
    opts[:server] = ec2uri.host
    if ec2uri.path.downcase.include?("eucalyptus")
      opts[:path] = ec2uri.path
      opts[:port] = ec2uri.port
      if ec2uri.class == URI::HTTPS
        opts[:use_ssl] = true
      else
        opts[:use_ssl] = false
      end
    end
    @ec2 = AWSAPI::EC2::Base.new(opts)
  else
    @ec2 = AWSAPI::EC2::Base.new(opts)
  end

  if ENV['ELB_URL']
    opts[:server] = URI.parse(ENV['ELB_URL']).host
    @elb = AWSAPI::ELB::Base.new(opts)
  else
    @elb = AWSAPI::ELB::Base.new(opts)
  end

  if ENV['AS_URL']
    opts[:server] = URI.parse(ENV['AS_URL']).host
    @as = AWSAPI::Autoscaling::Base.new(opts)
  else
    @as = AWSAPI::Autoscaling::Base.new(opts)
  end

  if ENV['RDS_URL']
    opts[:server] = URI.parse(ENV['RDS_URL']).host
    @rds = AWSAPI::RDS::Base.new(opts)
  else
    @rds = AWSAPI::RDS::Base.new(opts)
  end

  if ENV['AWS_CLOUDWATCH_URL']
    opts[:server] = URI.parse(ENV['AWS_CLOUDWATCH_URL']).host
    @cw = AWSAPI::Cloudwatch::Base.new(opts)
  else
    @cw = AWSAPI::Cloudwatch::Base.new(opts)
  end

  puts ""
  puts "Server Endpoints Configured"
  puts "--"
  puts "@ec2.default_host (Elastic Compute Cloud) : #{@ec2.default_host}"
  puts "@elb.default_host (Elastic Load Balancer) : #{@elb.default_host}"
  puts "@as.default_host (Autoscaling) : #{@as.default_host}"
  puts "@rds.default_host (Relational DB Service) : #{@rds.default_host}"
  puts "@cw.default_host (Cloudwatch) : #{@cw.default_host}"
  puts ""

end

require 'pp'
include AWS

