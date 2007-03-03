require 'test/unit'

# include the test cases that are part of this suite.
# these are broken out into the same functional groups
# as the module components in the lib/EC2 dir.
require 'tc_ec2_base'
require 'tc_images'
require 'tc_image_attributes'
require 'tc_keypairs'
require 'tc_instances'
require 'tc_responses'
require 'tc_security_groups'
require 'tc_version'

require File.dirname(__FILE__) + '/../lib/EC2'
