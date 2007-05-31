require 'test/unit'

begin
  require 'rubygems'
  require 'mocha'
  require 'stubba'
rescue LoadError
  abort "You need rubygems and mocha gems installed to run tests"
end

require File.dirname(__FILE__) + '/../lib/EC2'

