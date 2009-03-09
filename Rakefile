require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

# read the contents of the gemspec, eval it, and assign it to 'spec'
# this lets us maintain all gemspec info in one place.  Nice and DRY.
spec = eval(IO.read("amazon-ec2.gemspec"))

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Package and then install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{VER}}
end

desc "Package and then install the gem locally omitting documentation"
task :install_nodoc => [:package] do
  sh %{sudo gem install --no-ri --no-rdoc pkg/#{GEM}-#{VER}}
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = 'doc'
  rd.options = spec.rdoc_options
end

task :default => :test