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
  
  # The make_request() and ec2_error? methods, which are shared by all, will raise any 
  # exceptions encountered along the way as it converses with EC2.
  #
  # Exception Handling: If for some reason an error occurrs when executing a method
  # (e.g. its arguments were incorrect, or it simply failed) then an exception will 
  # be thrown.  The exceptions are defined in exceptions.rb as individual classes and should
  # match the exceptions that Amazon has defined for EC2.  If the exception raised cannot be
  # identified then a more generic exception class will be thrown.
  #
  # The implication of this is that you need to be prepared to handle any exceptions that
  # may be raised by this library in YOUR code with a 'rescue' clauses.  It is up to you
  # how gracefully you want to handle these exceptions that are raised.
  
  # Credits :
  # I learned the magic of making an OpenStruct object able to respond as a fully Enumerable 
  # object (responds to .each, etc.) thanks to a great blog article on Struct and OpenStruct 
  # at http://errtheblog.com/post/30
  #
  # Thanks to Sean Knapp for the XmlSimple response patch which greatly simplified the response
  # mechanism for the whole library while making it more accurate and much less brittle to boot!
  #
  
  require 'xmlsimple'
  
  #Introduction:
  #  
  # The Response object is created when a call is made to EC2 and an XML response is returned.
  # The XML response from EC2 is parsed using XmlSimple and the data structures it contains
  # are mapped onto this Response object.
  #
  # Your code will need to extract the necessary data from this object directly.
  #
  # The Response object inherits from the OpenStruct object class.  It also includes
  # the Enumerable module and some additional methods have been overriden so
  # the the Response object can behave like a fully Enumerable object.  Normally 
  # an OpenStruct object does not have these Enumberable methods.  e.g.:
  #
  #   #members
  #   #each
  #   #each_pair
  #   #[]
  #   #[]=
  #
  # If the request to EC2 results in an Exception instead of a successful response
  # then that exception will be thrown and you will need to rescue it in your code.
  #
  # All Exceptions that are known are defined in EC2/exceptions.rb and they all inherit from EC2:Error.
  #
  # See the file README.txt for more information on using the Response object.
  #
  # This object type is never directly instanciated by user code.
  #
  #Required Arguments:
  #
  # none
  #
  #Optional Arguments:
  # none
  #
  class Response < OpenStruct
    
    include Enumerable
    
    #Required Arguments:
    #
    # :xml => http_xml (The response.body from a Net::HTTP response)
    #
    #Optional Arguments:
    # :parse_options defines the options that you need to pass to XmlSimple.
    # :parse_options => Hash (default : { 'ForceArray' => ['item'], 'SuppressEmpty' => nil } )
    #
    def self.parse(options = {})
      options = {
        :xml => "",
        :parse_options => { 'ForceArray' => ['item'], 'SuppressEmpty' => nil }
      }.merge(options)
      return Response.new(XmlSimple.xml_in(options[:xml], options[:parse_options])) 
    end
    
    
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
    
    
    def initialize(data)
      super(data)
      convert(self)
    end
    
    
    private 
    def convert(obj)
      if (obj.class == Response)
        obj.each_pair { |k,v|
          obj[k] = convert(v)
        }
        return obj
      elsif (obj.class == Hash)
        # Hashes make good Responses already
        return Response.new(obj)
      elsif (obj.class == Array)
        # With arrays, need to 
        new_arr = []
        obj.each { |elem|
          new_arr << convert(elem)
        }
        return new_arr
      else
        return obj
      end
    end
    
  end
  
end