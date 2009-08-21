#--
# AWS EC2 CLIENT ERROR CODES
# AWS EC2 can throw error exceptions that contain a '.' in them.
# since we can't name an exception class with that '.' I compressed
# each class name into the non-dot version.  This allows us to retain
# the granularity of the exception.
#++

module AWS

  # All AWS errors are superclassed by Error < RuntimeError
  class Error < RuntimeError; end

  # CLIENT : A client side argument error
  class ArgumentError < Error; end

  # EC2 : User not authorized.
  class AuthFailure < Error; end

  # EC2 : Invalid AWS Account
  class InvalidClientTokenId < Error; end

  # EC2 : Invalid Parameters for Value
  class InvalidParameterValue < Error; end

  # EC2 : Specified AMI has an unparsable manifest.
  class InvalidManifest < Error; end

  # EC2 : Specified AMI ID is not valid.
  class InvalidAMIIDMalformed < Error; end

  # EC2 : Specified AMI ID does not exist.
  class InvalidAMIIDNotFound < Error; end

  # EC2 : Specified AMI ID has been deregistered and is no longer available.
  class InvalidAMIIDUnavailable < Error; end

  # EC2 : Specified instance ID is not valid.
  class InvalidInstanceIDMalformed < Error; end

  # EC2 : Specified instance ID does not exist.
  class InvalidInstanceIDNotFound < Error; end

  # EC2 : Specified keypair name does not exist.
  class InvalidKeyPairNotFound < Error; end

  # EC2 : Attempt to create a duplicate keypair.
  class InvalidKeyPairDuplicate < Error; end

  # EC2 : Specified group name does not exist.
  class InvalidGroupNotFound < Error; end

  # EC2 : Attempt to create a duplicate group.
  class InvalidGroupDuplicate < Error; end

  # EC2 : Specified group can not be deleted because it is in use.
  class InvalidGroupInUse < Error; end

  # EC2 : Specified group name is a reserved name.
  class InvalidGroupReserved < Error; end

  # EC2 : Attempt to authorize a permission that has already been authorized.
  class InvalidPermissionDuplicate < Error; end

  # EC2 : Specified permission is invalid.
  class InvalidPermissionMalformed < Error; end

  # EC2 : Specified reservation ID is invalid.
  class InvalidReservationIDMalformed < Error; end

  # EC2 : Specified reservation ID does not exist.
  class InvalidReservationIDNotFound < Error; end

  # EC2 : User has reached max allowed concurrent running instances.
  class InstanceLimitExceeded < Error; end

  # EC2 : An invalid set of parameters were passed as arguments
  class InvalidParameterCombination < Error; end

  # EC2 : An unknown parameter was passed as an argument
  class UnknownParameter < Error; end

  # EC2 : The user ID is neither in the form of an AWS account ID or one
  # of the special values accepted by the owner or executableBy flags
  # in the DescribeImages call.
  class InvalidUserIDMalformed < Error; end

  # EC2 : The value of an item added to, or removed from, an image attribute is invalid.
  class InvalidAMIAttributeItemValue < Error; end

  # ELB : The Load balancer specified was not found.
  class LoadBalancerNotFound < Error; end

  # ELB :
  class ValidationError < Error; end

  # ELB :
  class DuplicateLoadBalancerName < Error; end

  # ELB :
  class TooManyLoadBalancers < Error; end

  # ELB :
  class InvalidInstance < Error; end

  # ELB :
  class InvalidConfigurationRequest < Error; end

  # Server : Internal AWS EC2 Error.
  class InternalError < Error; end

  # Server : There are not enough available instances to satisfy your minimum request.
  class InsufficientInstanceCapacity < Error; end

  # Server : The server is overloaded and cannot handle the request.
  class Unavailable < Error; end

  # Server : The provided signature does not match.
  class SignatureDoesNotMatch < Error; end

end

