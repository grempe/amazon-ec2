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
    # The GetConsoleOutput operation retrieves console output that has been posted for the specified instance.
    #
    # Instance console output is buffered and posted shortly after instance boot, reboot and once the instance
    # is terminated. Only the most recent 64 KB of posted output is available. Console output is available for
    # at least 1 hour after the most recent post.
    #
    #Required Arguments:
    #
    # :instance_id => String (default : "")
    #
    #Optional Arguments:
    #
    # none
    #
    def get_console_output( options ={} )

      options = {:instance_id => ""}.merge(options)

      raise ArgumentError, "No instance ID provided" if options[:instance_id].nil? || options[:instance_id].empty?

      params = { "InstanceId" => options[:instance_id] }

      return response_generator(:action => "GetConsoleOutput", :params => params)

    end
  end

end
