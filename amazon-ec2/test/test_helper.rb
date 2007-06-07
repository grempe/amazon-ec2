%w[ test/unit rubygems test/spec mocha stubba ].each { |f| 
  begin
    require f
  rescue LoadError
    abort "Unable to load required gem for test: #{f}"
  end
}

require File.dirname(__FILE__) + '/../lib/EC2'

