#--
# AWS ERROR CODES
# AWS can throw error exceptions that contain a '.' in them.
# since we can't name an exception class with that '.' I compressed
# each class name into the non-dot version which allows us to retain
# the granularity of the exception.
#++

module AWS

  # All AWS errors are superclassed by Error < RuntimeError
  class Error < RuntimeError; end

  # CLIENT : A client side argument error
  class ArgumentError < Error; end

  # Elastic Compute Cloud
  ############################

  # EC2 : User has the maximum number of allowed IP addresses.
  class AddressLimitExceeded < Error; end

  # EC2 : The limit on the number of Amazon EBS volumes attached to one instance has been exceeded.
  class AttachmentLimitExceeded < Error; end

  # EC2 : User not authorized.
  class AuthFailure < Error; end

  # EC2 : Volume is in incorrect state
  class IncorrectState < Error; end

  # EC2 : User has max allowed concurrent running instances.
  class InstanceLimitExceeded < Error; end

  # EC2 : The value of an item added to, or removed from, an image attribute is invalid.
  class InvalidAMIAttributeItemValue < Error; end

  # EC2 : Specified AMI ID is not valid.
  class InvalidAMIIDMalformed < Error; end

  # EC2 : Specified AMI ID does not exist.
  class InvalidAMIIDNotFound < Error; end

  # EC2 : Specified AMI ID has been deregistered and is no longer available.
  class InvalidAMIIDUnavailable < Error; end

  # EC2 : The instance cannot detach from a volume to which it is not attached.
  class InvalidAttachmentNotFound < Error; end

  # EC2 : The device to which you are trying to attach (i.e. /dev/sdh) is already in use on the instance.
  class InvalidDeviceInUse < Error; end

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

  # EC2 : Specified AMI has an unparsable manifest.
  class InvalidManifest < Error; end

  # EC2 : RunInstances was called with minCount and maxCount set to 0 or minCount > maxCount.
  class InvalidParameterCombination < Error; end

  # EC2 : The value supplied for a parameter was invalid.
  class InvalidParameterValue < Error; end

  # EC2 : Attempt to authorize a permission that has already been authorized.
  class InvalidPermissionDuplicate < Error; end

  # EC2 : Specified permission is invalid.
  class InvalidPermissionMalformed < Error; end

  # EC2 : Specified reservation ID is invalid.
  class InvalidReservationIDMalformed < Error; end

  # EC2 : Specified reservation ID does not exist.
  class InvalidReservationIDNotFound < Error; end

  # EC2 : The snapshot ID that was passed as an argument was malformed.
  class InvalidSnapshotIDMalformed < Error; end

  # EC2 : The specified snapshot does not exist.
  class InvalidSnapshotIDNotFound < Error; end

  # EC2 : The user ID is neither in the form of an AWS account ID or one
  # of the special values accepted by the owner or executableBy flags
  # in the DescribeImages call.
  class InvalidUserIDMalformed < Error; end

  # EC2 : Reserved Instances ID not found.
  class InvalidReservedInstancesId < Error; end

  # EC2 : Reserved Instances Offering ID not found.
  class InvalidReservedInstancesOfferingId < Error; end

  # EC2 : The volume ID that was passed as an argument was malformed.
  class InvalidVolumeIDMalformed < Error; end

  # EC2 : The volume specified does not exist.
  class InvalidVolumeIDNotFound < Error; end

  # EC2 : The volume already exists in the system.
  class InvalidVolumeIDDuplicate < Error; end

  # EC2 : The specified volume ID and instance ID are in different Availability Zones.
  class InvalidVolumeIDZoneMismatch < Error; end

  # EC2 : The zone specified does not exist.
  class InvalidZoneNotFound < Error; end

  # EC2 : Insufficient Reserved Instances capacity.
  class InsufficientReservedInstancesCapacity < Error; end

  # EC2 : The instance specified does not support EBS.
  class NonEBSInstance < Error; end

  # EC2 : The limit on the number of Amazon EBS snapshots in the pending state has been exceeded.
  class PendingSnapshotLimitExceeded < Error; end

  # EC2 : Your current quota does not allow you to purchase the required number of reserved instances.
  class ReservedInstancesLimitExceeded < Error; end

  # EC2 : The limit on the number of Amazon EBS snapshots has been exceeded.
  class SnapshotLimitExceeded < Error; end

  # EC2 : An unknown parameter was passed as an argument
  class UnknownParameter < Error; end

  # EC2 : The limit on the number of Amazon EBS volumes has been exceeded.
  class VolumeLimitExceeded < Error; end

  # Server Error Codes
  ###

  # Server : Internal Error.
  class InternalError < Error; end

  # Server : Not enough available addresses to satisfy your minimum request.
  class InsufficientAddressCapacity < Error; end

  # Server : There are not enough available instances to satisfy your minimum request.
  class InsufficientInstanceCapacity < Error; end

  # Server : There are not enough available reserved instances to satisfy your minimum request.
  class InsufficientReservedInstanceCapacity < Error; end

  # Server : The server is overloaded and cannot handle the request.
  class Unavailable < Error; end

  # Elastic Load Balancer
  ############################

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

  # API Errors
  ############################

  # Server : Invalid AWS Account
  class InvalidClientTokenId < Error; end

  # Server : The provided signature does not match.
  class SignatureDoesNotMatch < Error; end

end

