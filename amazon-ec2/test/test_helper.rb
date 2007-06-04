require 'test/unit'

begin
  require 'rubygems'
  require 'mocha'
  require 'stubba'
rescue LoadError
  abort "Unable to load some required gems needed to run tests!"
end

require File.dirname(__FILE__) + '/../lib/EC2'

