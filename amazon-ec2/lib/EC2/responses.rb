# Amazon Web Services EC2 Query API Ruby library.  This library was 
# heavily modified from original Amazon Web Services sample code 
# and packaged as a Ruby Gem by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  # There are two major types of responses that can come back from EC2#method calls:
  #
  # * A 'Set' Array which is a collection of objects
  # * A 'Response' object (Response or Subclasses) which encapsulates data returned 
  #   as a result of running the method.  In this case the object is an OpenStruct 
  #   and is Enumerable so you can iterate over all of the data returned.
  # * Note regarding Boolean responses.  Those EC2 methods that simply respond with a 
  #   'true' when called will return an empty sub-class of the Response object that
  #   matches the calling method.  The presence of this object (as opposed to an Exception)
  #   means that that method call succeeded.
  #
 
  # The make_request() and ec2_error? methods, which are shared by all, will raise any 
  # exceptions encountered along the way as it converses with EC2.
  #
  # Exception Handling:  A call to any of these methods will respond with one of the
  # types mentioned above.  If for some reason an error occurrs when executing a method
  # (e.g. its arguments were incorrect, or it simply failed) then an exception will 
  # be thrown.  The exceptions are defined in exceptions.rb as individual classes and should
  # match the exceptions that Amazon has defined for EC2.  If the exception raised cannot be
  # identified then a more generic exception class will be thrown.
  #
  # The implication of this is that you need to be prepared to handle any exceptions that
  # may be raised by this library in YOUR code with 'rescue' clauses.  It is up to you
  # how gracefully you want to handle these exceptions that are raised.
  
  
  # The superclass for all general responses.  A Set (or one of its sub-classes)
  # may return an Array of these objects.
  #
  # I learned the magic of making an OpenStruct object able to respond as a fully Enumerable 
  # object (responds to .each, etc.) thanks to a great blog article on Struct and OpenStruct 
  # at http://errtheblog.com/post/30
  #
  class Response < OpenStruct
    
    include Enumerable
    
    def members
      methods(false).grep(/=/).map { |m| m[0...-1] }
    end
    
    def each
      members.each do |method|
        yield send(method)
      end
      self
    end
    
    def each_pair
      members.each do |method|
        yield method, send(method)
      end
      self
    end
     
    def [](member)
      send(member)
    end
    
    def []=(member, value)
      send("#{member}=", value)
    end
    
  end
  
  # The superclass for all List objects which inherits from Array since we are
  # just using these objects to collect up other responses (e.g. a collection of Images)
  class Set < Array
  end
  
  # Sub-Classes Of 'Response'
  # These are the responses that we need to define as they will be filled with data
  # that needs to be encapsulated (rather than a simple boolean).
  ################################################
  
  class Item < Response
  end
  
  class DeregisterImageResponse < Response
  end
  
  class RegisterImageResponse < Response
  end
  
  class RebootInstancesResponse < Response
  end
  
  class RunInstancesResponse < Response
  end
  
  class CreateKeyPairResponse < Response
  end
  
  class DeleteKeyPairResponse < Response
  end
  
  class GetConsoleOutputResponse < Response
  end
  
  class ModifyImageAttributeResponse < Response
  end
  
  class ResetImageAttributeResponse < Response
  end
  
  class DescribeImageAttributeResponse < Response
  end
  
  class CreateSecurityGroupResponse < Response
  end
  
  class DeleteSecurityGroupResponse < Response
  end
  
  class AuthorizeSecurityGroupIngressResponse < Response
  end
  
  class RevokeSecurityGroupIngressResponse < Response
  end
  
  # Sub-Classes of 'Set'
  ################################################
  
  class DescribeImagesResponseSet < Set
  end
  
  class DescribeInstancesResponseSet < Set
  end
  
  class TerminateInstancesResponseSet < Set
  end
  
  class GroupResponseSet < Set
  end
  
  class InstancesResponseSet < Set
  end
  
  class DescribeKeyPairsResponseSet < Set
  end
  
  class LaunchPermissionResponseSet < Set
  end
  
  class DescribeSecurityGroupsResponseSet < Set
  end
  
  class IpPermissionsResponseSet < Set
  end
  
  class IpRangesResponseSet < Set
  end
  
end
