require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "amazon-ec2"
    gem.summary = %Q{Amazon EC2 Ruby Gem}
    gem.description = %Q{A Ruby library for accessing the Amazon Web Services EC2, ELB, RDS, Cloudwatch, and Autoscaling APIs.}
    gem.email = "glenn@rempe.us"
    gem.homepage = "http://github.com/grempe/amazon-ec2"
    gem.authors = ["Glenn Rempe"]
    gem.rdoc_options = ["--title", "amazon-ec2 documentation", "--line-numbers", "--main", "README.rdoc"]
    gem.rubyforge_project = 'amazon-ec2'
    gem.add_dependency('xml-simple', '>= 1.0.12')
    gem.add_development_dependency('mocha', '>= 0.9.8')
    gem.add_development_dependency('test-spec', '>= 0.10.0')
    gem.add_development_dependency('rcov', '>= 0.9.6')
    gem.add_development_dependency('perftools.rb', '>= 0.3.9')
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: [sudo] gem install jeweler"
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
    abort "RCov is not available. In order to run rcov, you must: [sudo] gem install rcov"
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
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    #t.files   = ['lib/**/*.rb']
  end
rescue LoadError
  puts "YARD (or a dependency) not available. Install it with: [sudo] gem install yard"
end

desc "Generate a perftools.rb profile"
task :profile do
  system("CPUPROFILE=perftools/ec2prof RUBYOPT='-r/Library/Ruby/Gems/1.8/gems/perftools.rb-0.3.2/lib/perftools.bundle' ruby -r'rubygems' bin/ec2-gem-profile.rb")
  system("pprof.rb --text --ignore=Gem perftools/ec2prof > perftools/ec2prof-results.txt")
  system("pprof.rb --dot --ignore=Gem perftools/ec2prof > perftools/ec2prof-results.dot")
end

