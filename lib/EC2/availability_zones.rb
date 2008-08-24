#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:grempe@rubyforge.org)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

module EC2

  class Base

    #Amazon Developer Guide Docs:
    #
    # The DescribeAvailabilityZones operation describes availability zones that are currently
    # available to the account and their states.
    #
    # An optional list of zone names can be passed.
    #
    #Required Arguments:
    #
    # none
    #
    #Optional Arguments:
    #
    # :zone_name => Array (default : [])
    #

    def describe_availability_zones( options = {} )

      options = { :zone_name => [] }.merge(options)

      params = pathlist("ZoneName", options[:zone_name] )

      return response_generator(:action => "DescribeAvailabilityZones", :params => params)

    end
  end
end
