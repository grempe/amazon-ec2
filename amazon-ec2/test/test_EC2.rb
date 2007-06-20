#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The EC2 method " do
  
  setup do
  end
  
  specify "EC2::Base attribute readers should be available" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                                       :secret_access_key => "not a secret",
                                       :use_ssl => true,
                                       :server => "foo.example.com" )
    
    @ec2.use_ssl.should.equal true
    @ec2.port.should.equal 443
    @ec2.server.should.equal "foo.example.com"
  end
  
  
  specify "EC2::Base should work with insecure connections as well" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                                       :secret_access_key => "not a secret",
                                       :use_ssl => false,
                                       :server => "foo.example.com" )
    
    @ec2.use_ssl.should.equal false
    @ec2.port.should.equal 80
    @ec2.server.should.equal "foo.example.com"
  end
  
  
  specify "EC2.canonical_string(path) should data that is stripped of ?,&,= " do
    path = "?name1=value1&name2=value2&name3=value3"
    EC2.canonical_string(path).should.equal "name1value1name2value2name3value3"
  end
  
  specify "EC2.encode should return the expected string" do
    EC2.encode("secretaccesskey", "foobar123", urlencode=true).should.equal "e3jeuDc3DIX2mW8cVqWiByj4j5g%3D"
    EC2.encode("secretaccesskey", "foobar123", urlencode=false).should.equal "e3jeuDc3DIX2mW8cVqWiByj4j5g="
  end
  
end
