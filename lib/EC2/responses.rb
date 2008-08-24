#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:grempe@rubyforge.org)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://amazon-ec2.rubyforge.org
#++

# This allows us to access hash values as if they were methods
# e.g. foo[:bar] can be accessed as foo.bar

class Hash
  def method_missing(meth, *args, &block)
    if args.size == 0
      self[meth.to_s] || self[meth.to_sym]
    end
  end
end

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


  require 'rubygems'
  begin
    require 'xmlsimple' unless defined? XmlSimple
  rescue Exception => e
    require 'xml-simple' unless defined? XmlSimple
  end

  class Response

    def self.parse(options = {})
      options = {
        :xml => "",
        :parse_options => { 'ForceArray' => ['item'], 'SuppressEmpty' => nil }
      }.merge(options)

      # NOTE: Parsing the response as a nested set of Response objects was extremely
      # memory intensive and appeared to leak (the memory was not freed on subsequent requests).
      # It was changed to return the raw XmlSimple response.

      response = XmlSimple.xml_in(options[:xml], options[:parse_options])

      return response
    end

  end  # class Response

end  # module EC2
