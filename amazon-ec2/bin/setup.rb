#!/usr/bin/env ruby
if ENV['AMAZON_ACCESS_KEY_ID'] && ENV['AMAZON_SECRET_ACCESS_KEY']
  @ec2 = EC2::AWSAuthConnection.new( 
    :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY'] 
  )
end

include EC2 
