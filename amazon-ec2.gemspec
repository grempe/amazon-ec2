Gem::Specification.new do |s|
  s.name = %q{amazon-ec2}
  s.version = "0.2.10"
  s.summary = %q{An interface library that allows Ruby or Ruby on Rails applications to easily connect to the HTTP 'Query API' for the Amazon Web Services Elastic Compute Cloud (EC2) and manipulate server instances.}
  s.email = %q{glenn.rempe@gmail.com}
  s.homepage = %q{http://github.com/grempe/amazon-ec2/}
  s.description = %q{An interface library that allows Ruby or Ruby on Rails applications to easily connect to the HTTP 'Query API' for the Amazon Web Services Elastic Compute Cloud (EC2) and manipulate server instances.}
  s.has_rdoc = true
  s.authors = ["Glenn Rempe"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.rdoc", "Rakefile", "bin/ec2-gem-example.rb", "bin/ec2sh", "bin/setup.rb", "config/hoe.rb", "config/requirements.rb", "lib/EC2.rb", "lib/EC2/console.rb", "lib/EC2/elastic_ips.rb", "lib/EC2/exceptions.rb", "lib/EC2/image_attributes.rb", "lib/EC2/images.rb", "lib/EC2/instances.rb", "lib/EC2/keypairs.rb", "lib/EC2/products.rb", "lib/EC2/responses.rb", "lib/EC2/security_groups.rb", "lib/EC2/version.rb", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "test/test_EC2.rb", "test/test_EC2_console.rb", "test/test_EC2_elastic_ips.rb", "test/test_EC2_image_attributes.rb", "test/test_EC2_images.rb", "test/test_EC2_instances.rb", "test/test_EC2_keypairs.rb", "test/test_EC2_products.rb", "test/test_EC2_responses.rb", "test/test_EC2_security_groups.rb", "test/test_EC2_version.rb", "test/test_helper.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.rhtml"]
  s.test_files = ["test/test_EC2.rb", "test/test_EC2_console.rb", "test/test_EC2_elastic_ips.rb", "test/test_EC2_image_attributes.rb", "test/test_EC2_images.rb", "test/test_EC2_instances.rb", "test/test_EC2_keypairs.rb", "test/test_EC2_products.rb", "test/test_EC2_responses.rb", "test/test_EC2_security_groups.rb", "test/test_EC2_version.rb", "test/test_helper.rb"]
  s.rdoc_options = ["--quiet", "--title", "amazon-ec2 documentation", "--opname", "index.html", "--line-numbers", "--main", "README.txt", "--inline-source"]
  s.extra_rdoc_files = ["README.rdoc", "History.txt", "License.txt"]

  s.add_dependency(%q<xml-simple>, [">= 1.0.11"])
  s.add_dependency(%q<mocha>, [">= 0.4.0"])
  s.add_dependency(%q<test-spec>, [">= 0.3.0"])
  s.add_dependency(%q<rcov>, [">= 0.8.0.2"])
  s.add_dependency(%q<syntax>, [">= 1.0.0"])
  s.add_dependency(%q<RedCloth>, [">= 3.0.4"])

  s.autorequire = %q{EC2}
  s.executables = ["ec2-gem-example.rb", "ec2sh", "setup.rb"]
  s.require_paths = ["lib"]
end
