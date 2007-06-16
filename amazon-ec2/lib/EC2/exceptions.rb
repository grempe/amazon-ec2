#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Elastic Workbench, LLC
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

module EC2
  
  # OUR CUSTOM ERROR CODES
  
  # All of our errors are superclassed by Error < RuntimeError
  class Error < RuntimeError; end
  
  # A client side only argument error
  class ArgumentError < Error; end
  
  # AWS EC2 CLIENT ERROR CODES
  
  # AWS EC2 can throw error exceptions that contain a '.' in them.
  # since we can't name an exception class with that '.' I compressed
  # each class name into the non-dot version.  This allows us to retain
  # the granularity of the exception.
  
  # User not authorized.
  class AuthFailure < Error; end
  
  # Specified AMI has an unparsable manifest.
  class InvalidManifest < Error; end
  
  # Specified AMI ID is not valid.
  class InvalidAMIIDMalformed < Error; end
  
  # Specified AMI ID does not exist.
  class InvalidAMIIDNotFound < Error; end
  
  # Specified AMI ID has been deregistered and is no longer available.
  class InvalidAMIIDUnavailable < Error; end
  
  # Specified instance ID is not valid.
  class InvalidInstanceIDMalformed < Error; end
  
  # Specified instance ID does not exist.
  class InvalidInstanceIDNotFound < Error; end
  
  # Specified keypair name does not exist.
  class InvalidKeyPairNotFound < Error; end
  
  # Attempt to create a duplicate keypair.
  class InvalidKeyPairDuplicate < Error; end
  
  # Specified group name does not exist.
  class InvalidGroupNotFound < Error; end
  
  # Attempt to create a duplicate group.
  class InvalidGroupDuplicate < Error; end
  
  # Specified group can not be deleted because it is in use.
  class InvalidGroupInUse < Error; end
  
  # Specified group name is a reserved name.
  class InvalidGroupReserved < Error; end
  
  # Attempt to authorize a permission that has already been authorized.
  class InvalidPermissionDuplicate < Error; end
  
  # Specified permission is invalid.
  class InvalidPermissionMalformed < Error; end
  
  # Specified reservation ID is invalid.
  class InvalidReservationIDMalformed < Error; end
  
  # Specified reservation ID does not exist.
  class InvalidReservationIDNotFound < Error; end
  
  # User has reached max allowed concurrent running instances.
  class InstanceLimitExceeded < Error; end
  
  # An invalid set of parameters were passed as arguments
  # e.g. RunInstances was called with minCount and maxCount set to 0 or minCount > maxCount.
  class InvalidParameterCombination < Error; end
  
  # An unknown parameter was passed as an argument
  class UnknownParameter < Error #:nodoc:
  end
  
  # The user ID is neither in the form of an AWS account ID or one 
  # of the special values accepted by the owner or executableBy flags 
  # in the DescribeImages call.
  class InvalidUserIDMalformed < Error; end
  
  # The value of an item added to, or removed from, an image attribute is invalid.
  class InvalidAMIAttributeItemValue < Error; end
  
  # AWS EC2 SERVER ERROR CODES
  
  # Internal AWS EC2 Error.
  class InternalError < Error; end
  
  # There are not enough available instances to satify your minimum request.
  class InsufficientInstanceCapacity < Error; end
  
  # The server is overloaded and cannot handle request.
  class Unavailable < Error; end
  
end
