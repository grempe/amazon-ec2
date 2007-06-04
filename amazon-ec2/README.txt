= Amazon Web Services Elastic Compute Cloud (EC2) Ruby Gem

== About amazon-ec2

Amazon Web Services offers a compute power on demand capability known as the Elastic Compute Cloud (EC2).  Using the current API's the compute resources in the cloud can be provisioned on demand by making SOAP or HTTP Query API calls to EC2.
 
This 'amazon-ec2' Ruby Gem is an interface library that can be used to interact with the Amazon EC2 system using the Query API (No SOAP please...).

For more information please visit the project homepage at: http://amazon-ec2.rubyforge.org or the EC2 website at http://aws.amazon.com/ec2


== Installation

This gem follows the standard conventions for installation on any system with Ruby and RubyGems installed.  If you have worked with gems before this will look very familiar.

=== Installation pre-requisites

Before you can make use of this gem you will need an Amazon Web Services developer account which you can sign up for at https://aws-portal.amazon.com/gp/aws/developer/registration/index.html.  This account must also be specifically enabled for Amazon EC2 usage.  AWS will provide you with an 'AWS Access Key ID' and a 'Secret Access Key' which will allow you to authenticate any API calls you make and ensure correct billing to you for usage of the service.  Take note of these (and keep them secret!).

=== Installing the gem (Mac OS X / Linux)

  sudo gem install amazon-ec2

=== Installing the gem (Windows)

  gem install amazon-ec2


== Usage Examples

The library exposes one main interface class EC2::AWSAuthConnection.  It is through an instance of this class that you will perform all the operations for using the EC2 service including query string header signing.

The public methods on EC2::AWSAuthConnection closely mirror the EC2 Query API, and as such the Query API Reference in the EC2 Developer Guide ( http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=84 ) will prove helpful.

=== Ruby script usage example:

  #!/usr/bin/env ruby
  
  require 'rubygems'
  require 'ec2'
  
  AWS_ACCESS_KEY_ID = '--YOUR AWS ACCESS KEY ID--'
  AWS_SECRET_ACCESS_KEY = '--YOUR AWS SECRET ACCESS KEY--'
    
  ec2 = EC2::AWSAuthConnection.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
   
  puts "----- listing images -----"
  ec2.describe_images.each do |image|
    image.members.each do |member|
      puts "#{member} => #{image[member]}" 
    end
  end

=== Ruby on Rails usage example:

<b>config/environment.rb</b>

  require 'EC2'

<b>app/controllers/my_controller.rb</b>

  class MyController < ApplicationController
    def index
      # Setup connection to Amazon EC2
      ec2 = EC2::AWSAuthConnection.new("YOUR AWS ACCESS KEY ID", "YOUR AWS SECRET ACCESS KEY")
      @ec2_images = ec2.describe_images()
    end
  end

<b>app/views/my/index.rhtml</b>

  <% for image in @ec2_images %>
    <% for member in image.members %>
      <%= "#{member} => #{image[member]}" %><br />
    <% end %>
    <br />
  <% end %>


== Additional Resources

=== Information

* Amazon Web Services : http://aws.amazon.com
* amazon-ec2 GEM home : http://amazon-ec2.rubyforge.org

=== Project Tools

* Project Home : http://rubyforge.org/projects/amazon-ec2
* Downloads : http://rubyforge.org/frs/?group_id=2753
* Browse Code : http://rubyforge.org/scm/?group_id=2753
* Report Bugs : http://rubyforge.org/tracker/?group_id=2753
* Request Features : http://rubyforge.org/tracker/?group_id=2753
* Submit Patches : http://rubyforge.org/tracker/?group_id=2753

=== Related Projects

* Capazon : http://capazon.rubyforge.org

== Credits

The original sample code for this library was provided by Amazon Web Services, LLC.  Thanks to them for providing all of us with samples that got this started.

Thanks to Dr. Nic Williams and his great 'NewGem' Ruby Gem Generator.  This "gem" of a Gem helped me package up this code for distribution in a relative flash!  You can find Dr. Nic's NewGem generator at http://newgem.rubyforge.org.

== Contact

Comments, patches, and bug reports are welcome. Send an email to mailto:grempe@nospam@rubyforge.org or use the RubyForge forum for this project.

Enjoy!

Glenn Rempe
