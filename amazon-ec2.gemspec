GEM       = "amazon-ec2"
VER       = "0.2.15"
AUTHOR    = "Glenn Rempe"
EMAIL     = "glenn.rempe@gmail.com"
HOMEPAGE  = "http://github.com/grempe/amazon-ec2/"
SUMMARY   = "An interface library that allows Ruby applications to easily connect to the HTTP 'Query API' for the Amazon Web Services Elastic Compute Cloud (EC2) and manipulate cloud servers."

Gem::Specification.new do |s|
  s.name = GEM
  s.version = VER
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.summary = SUMMARY
  s.description = s.summary

  s.require_path = 'lib'
  s.autorequire = 'EC2'
  s.executables = ["ec2-gem-example.rb", "ec2sh", "setup.rb"]

  # get this easily and accurately by running 'Dir.glob("{lib,test}/**/*")'
  # in an IRB session.  However, GitHub won't allow that command hence
  # we spell it out.
  s.files = ["README.rdoc", "LICENSE", "CHANGELOG", "Rakefile", "lib/EC2", "lib/EC2/availability_zones.rb", "lib/EC2/console.rb", "lib/EC2/elastic_ips.rb", "lib/EC2/exceptions.rb", "lib/EC2/image_attributes.rb", "lib/EC2/images.rb", "lib/EC2/instances.rb", "lib/EC2/keypairs.rb", "lib/EC2/products.rb", "lib/EC2/responses.rb", "lib/EC2/security_groups.rb", "lib/EC2.rb", "test/test_EC2.rb", "test/test_EC2_availability_zones.rb", "test/test_EC2_console.rb", "test/test_EC2_elastic_ips.rb", "test/test_EC2_image_attributes.rb", "test/test_EC2_images.rb", "test/test_EC2_instances.rb", "test/test_EC2_keypairs.rb", "test/test_EC2_products.rb", "test/test_EC2_responses.rb", "test/test_EC2_security_groups.rb", "test/test_helper.rb"]
  s.test_files = ["test/test_EC2.rb", "test/test_EC2_console.rb", "test/test_EC2_elastic_ips.rb", "test/test_EC2_image_attributes.rb", "test/test_EC2_images.rb", "test/test_EC2_instances.rb", "test/test_EC2_keypairs.rb", "test/test_EC2_products.rb", "test/test_EC2_responses.rb", "test/test_EC2_security_groups.rb", "test/test_helper.rb"]

  s.has_rdoc = true
  s.rdoc_options = ["--quiet", "--title", "amazon-ec2 documentation", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source"]
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "LICENSE"]

  s.add_dependency 'xml-simple'
  s.add_dependency 'mocha'
  s.add_dependency 'test-spec'
  s.add_dependency 'rcov'
end
