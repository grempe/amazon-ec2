require 'rubygems'
require 'rake'
require 'yard'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "amazon-ec2"
  gem.summary = %Q{Amazon EC2 Ruby Gem}
  gem.description = %Q{A Ruby library for accessing the Amazon Web Services Elastic Compute Cloud (EC2), Elastic Load Balancer (ELB), Cloudwatch, and Autoscaling API's.}
  gem.email = "glenn@rempe.us"
  gem.homepage = "http://github.com/grempe/amazon-ec2"
  gem.authors = ["Glenn Rempe"]
  gem.rdoc_options = ["--title", "amazon-ec2 documentation", "--line-numbers", "--main", "README.rdoc"]
  gem.rubyforge_project = 'amazon-ec2'
  gem.add_dependency('xml-simple', '>= 1.0.12')
  gem.add_development_dependency('mocha', '>= 0.9.7')
  gem.add_development_dependency('test-spec', '>= 0.10.0')
  gem.add_development_dependency('relevance-rcov', '>= 0.8.5.1')
  gem.add_development_dependency('perftools.rb', '= 0.1.6')
end

# make the jeweler rubyforge tasks available.
Jeweler::RubyforgeTasks.new do |rubyforge|
  rubyforge.doc_task = "rdoc"
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
    test.rcov_opts << "--exclude /gems/,/Library/,spec"
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: [sudo] gem install relevance-rcov"
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

YARD::Rake::YardocTask.new do |t|
  #t.files   = ['lib/**/*.rb']
end

begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and YARD documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish YARD docs to RubyForge."
      task :docs => [:doc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/amazon-ec2/"
        local_dir = 'doc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

desc "Generate a perftools.rb profile"
task :profile do
  system("CPUPROFILE=perftools/ec2prof RUBYOPT='-r/usr/local/lib/ruby/gems/1.8/gems/perftools.rb-0.1.6/lib/perftools.bundle' ruby -r'rubygems' bin/ec2-gem-profile.rb")
  system("pprof.rb --text --ignore=Gem perftools/ec2prof > perftools/ec2prof-results.txt")
  system("pprof.rb --dot --ignore=Gem perftools/ec2prof > perftools/ec2prof-results.dot")
end