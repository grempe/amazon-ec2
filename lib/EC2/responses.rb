#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
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

  class Response

    def self.parse(options = {})
      options = { :xml => "" }.merge(options)
      response = Nokogiri::XML(options[:xml])
    end

  end  # class Response

  # monkey patch NokoGiri to provide #to_hash
  module Conversions #:nodoc:
    module Document #:nodoc:
      def to_hash
        root.to_hash
      end
    end

    module Node #:nodoc:
      CONTENT_ROOT = ''

      # Convert XML document to hash
      #
      # hash::
      #   Hash to merge the converted element into.
      def to_hash(hash = {})
        hash[name] ||= attributes_as_hash

        walker = lambda { |memo, parent, child, callback|
          next if child.blank? && 'file' != parent['type']

          if child.text?
            (memo[CONTENT_ROOT] ||= '') << child.content
            next
          end

          name = child.name

          child_hash = child.attributes_as_hash
          if memo[name]
            memo[name] = [memo[name]].flatten
            memo[name] << child_hash
          else
            memo[name] = child_hash
          end

          # Recusively walk children
          child.children.each { |c|
            callback.call(child_hash, child, c, callback)
          }
        }

        children.each { |c| walker.call(hash[name], self, c, walker) }
        hash
      end

      def attributes_as_hash
        Hash[*(attribute_nodes.map { |node|
          [node.node_name, node.value]
        }.flatten)]
      end
    end
  end

  Nokogiri::XML::Document.send(:include, Conversions::Document)
  Nokogiri::XML::Node.send(:include, Conversions::Node)

end  # module EC2
