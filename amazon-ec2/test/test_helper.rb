$:.unshift File.expand_path('../lib')
require "test/unit"
begin
  require 'rubygems'
  require 'mocha'
  require 'stubba'
rescue LoadError
  abort "You need mocha installed to run tests"
end
require "EC2"
