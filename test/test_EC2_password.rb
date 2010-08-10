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

context "The EC2 password " do

  before do
    @ec2 = AWS::EC2::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @get_password_data_response_body = <<-RESPONSE
    <GetPasswordDataResponse xmlns="http://ec2.amazonaws.com/doc/2010-06-15/">
      <instanceId>i-2574e22a</instanceId>
      <timestamp>2009-10-24 15:00:00</timestamp>
      <passwordData>TGludXggdmVyc2lvbiAyLjYuMTYteGVuVSAoYnVpbGRlckBwYXRjaGJhdC5hbWF6b25zYSkgKGdj</passwordData></GetPasswordDataResponse>
    RESPONSE

  end


  specify "should return an encrypted password encoded by base64 " do
    @ec2.stubs(:make_request).with('GetPasswordData', {"InstanceId"=>"i-2574e22a"}).
       returns stub(:body => @get_password_data_response_body, :is_a? => true)
    @ec2.get_password_data( :instance_id => "i-2574e22a" ).should.be.an.instance_of Hash
    response = @ec2.get_password_data( :instance_id => "i-2574e22a" )
    response.instanceId.should.equal "i-2574e22a"
    response.timestamp.should.equal "2009-10-24 15:00:00"
    response.passwordData.should.equal "TGludXggdmVyc2lvbiAyLjYuMTYteGVuVSAoYnVpbGRlckBwYXRjaGJhdC5hbWF6b25zYSkgKGdj"
  end


  specify "method get_password_data should raise an exception when called without nil/empty string arguments" do
    lambda { @ec2.get_password_data() }.should.raise(AWS::ArgumentError)
    lambda { @ec2.get_password_data(:instance_id => nil) }.should.raise(AWS::ArgumentError)
    lambda { @ec2.get_password_data(:instance_id => "") }.should.raise(AWS::ArgumentError)
  end


end
