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

context "The EC2 method " do

  before do
  end

  specify "AWS::EC2::Base attribute readers should be available" do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :use_ssl => true,
                          :server => "foo.example.com" )

    @ec2.use_ssl.should.equal true
    @ec2.port.should.equal 443
    @ec2.server.should.equal "foo.example.com"
  end

  specify "AWS::EC2::Base should work with insecure connections as well" do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :use_ssl => false,
                          :server => "foo.example.com" )

    @ec2.use_ssl.should.equal false
    @ec2.port.should.equal 80
    @ec2.server.should.equal "foo.example.com"
  end

  specify "AWS::EC2::Base should allow specification of port" do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :use_ssl => true,
                          :server => "foo.example.com",
                          :port => 8443 )

    @ec2.use_ssl.should.equal true
    @ec2.port.should.equal 8443
    @ec2.server.should.equal "foo.example.com"
  end

  specify "AWS.canonical_string(path) should conform to Amazon's requirements " do
    path = {"name1" => "value1", "name2" => "value2 has spaces", "name3" => "value3~"}
    if ENV['EC2_URL'].nil? || ENV['EC2_URL'] == 'https://ec2.amazonaws.com'
      AWS.canonical_string(path, 'ec2.amazonaws.com').should.equal "POST\nec2.amazonaws.com\n/\nname1=value1&name2=value2%20has%20spaces&name3=value3~"
    elsif ENV['EC2_URL'] == 'https://us-east-1.ec2.amazonaws.com'
      AWS.canonical_string(path, 'ec2.amazonaws.com').should.equal "POST\nus-east-1.ec2.amazonaws.com\n/\nname1=value1&name2=value2%20has%20spaces&name3=value3~"
    elsif ENV['EC2_URL'] == 'https://eu-west-1.ec2.amazonaws.com'
      AWS.canonical_string(path, 'ec2.amazonaws.com').should.equal "POST\neu-west-1.ec2.amazonaws.com\n/\nname1=value1&name2=value2%20has%20spaces&name3=value3~"
    end
  end

  specify "AWS.encode should return the expected string" do
    AWS.encode("secretaccesskey", "foobar123", urlencode=true).should.equal "CPzGGhtvlG3P3yp88fPZp0HKouUV8mQK1ZcdFGQeAug%3D"
    AWS.encode("secretaccesskey", "foobar123", urlencode=false).should.equal "CPzGGhtvlG3P3yp88fPZp0HKouUV8mQK1ZcdFGQeAug="
  end

end
