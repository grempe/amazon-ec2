require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "amazon-ec2"
    gem.summary = %Q{Amazon EC2 Ruby Gem}
    gem.description = %Q{An interface library that allows Ruby applications to easily connect to the HTTP 'Query API' for the Amazon Web Services Elastic Compute Cloud (EC2) and manipulate cloud servers.}
    gem.email = "glenn@rempe.us"
    gem.homepage = "http://github.com/grempe/amazon-ec2"
    gem.authors = ["Glenn Rempe"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings

#    gem.autorequire = 'EC2'
    gem.rdoc_options = ["--quiet", "--title", "amazon-ec2 documentation", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source"]

    gem.rubyforge_project = 'amazon-ec2'

    gem.add_dependency('xml-simple', '>= 1.0.12')
    gem.add_development_dependency('mocha', '>= 0.9.5')
    gem.add_development_dependency('test-spec', '>= 0.10.0')
    gem.add_development_dependency('rcov', '>= 0.8.1.2.0')

  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "amazon-ec2 #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/amazon-ec2/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end
