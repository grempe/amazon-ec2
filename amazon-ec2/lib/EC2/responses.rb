#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@elasticworkbench.com)
# Copyright:: Copyright (c) 2007 Glenn Rempe
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
  
  class Response < OpenStruct
    
    include Enumerable
    
    
    def self.parse(options = {})
      options = {
        :xml => "",
        :parse_options => { 'ForceArray' => ['item'], 'SuppressEmpty' => nil }
      }.merge(options)
      response = Response.new(XmlSimple.xml_in(options[:xml], options[:parse_options]))
      
      # set the xml attribute of the response object to contain the original XML that was
      # returned by amazon.  This allows anyone to bypass our parsing if desired and just
      # get right at the raw XML response.
      response.xml = options[:xml]
      return response
    end
    
    
    # Every member of an OpenStruct object has getters and setters, the latter of which
    # has a method ending in "=". Find all of these methods, excluding those defined on
    # parent classes.
    def members
      methods(false).sort.grep(/=/).map { |m| m[0...-1] } 
    end
    
    
    # Required by the Enumerable module. Iterate over each item in the members array
    # and pass as a value the block passed to each using yield.
    def each
      members.each do |method|
        yield send(method)
      end
      self
    end
    
    
    # Same as the each method, but with both key and value.
    #
    #Sample Use:
    # obj.each_pair { |k,v| puts "key: #{k}, value: #{v}" }
    def each_pair 
      members.each do |method|
        yield method, send(method)
      end
      self
    end
    
    
    # Alternative method for getting members.
    def [](member)
      send(member)
    end
    
    
    # Alternative method for setting members.
    def []=(member, value)
      send("#{member}=", value)
    end
    
    
    # Helper for converting to string which support a long and short version
    # to avoid recursion problems with parents.
    def to_string(short=false)
      s = "#<#{self.class}:0x#{(2 ** 32 + object_id).to_s(16).upcase}"
      if (short)
        s += " ..."
      else
        each_pair { |k,v|
          if (v == self.parent && v.kind_of?(Response))
            v = v.to_string(true)
          elsif (v.kind_of?(String))
            v = "\"#{v.gsub("\"", "\\\"")}\""
          elsif (v.kind_of?(NilClass))
            v = "nil"
          end
          s += " #{k}=#{v}"
        }
      end
      s += ">"
      return s
    end
    
    
    # Override of to string method.
    def to_s
      return to_string
    end
    
    
    private 
    
    # Initialize the object by passing data to the OpenStruct initialize method
    # and then converting ourself to guarantee we have top-to-bottom data 
    # representation as a Response object.
    def initialize(data, parent=nil)
      super(data)
      self.parent = parent
      Response.convert(self, parent)
    end
    
    
    # The "brains" of our Response class. This method takes an arbitray object and
    # depending on its class attempts to convert it.
    def self.convert(obj, parent)
      if (obj.kind_of?(Response))
        # Recursively convert the object.
        obj.each_pair { |k,v|
          if (v != obj.parent)
            obj[k] = convert(v, obj)
          end
        }
        return obj
      elsif (obj.kind_of?(Hash))
        # Hashes make good Responses already thanks to OpenStruct.
        return Response.new(obj, parent)
      elsif (obj.kind_of?(Array))
        # With arrays, make sure each element is appropriately converted.
        new_arr = []
        obj.each { |elem|
          new_arr << convert(elem, parent)
        }
        return new_arr
      else
        # At this point we're out of ideas, so let's hope it is a string.
        return obj
      end
    end

  end  # class Response < OpenStruct
  
end  # module EC2
