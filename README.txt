= Amazon Web Services Elastic Compute Cloud (EC2) Ruby Gem

== About amazon-ec2

Amazon Web Services offers a compute power on demand capability known as the Elastic Compute Cloud (EC2).  Using the current API's the compute resources in the cloud can be provisioned on demand by making SOAP or HTTP Query API calls to EC2.
 
This 'amazon-ec2' Ruby Gem is an interface library that can be used to interact with the Amazon EC2 system using the Query API (No SOAP please...).

For the most complete and up-to date README information please visit the project homepage at: http://amazon-ec2.rubyforge.org or the EC2 website at http://aws.amazon.com/ec2


== Installation

This gem follows the standard conventions for installation on any system with Ruby and RubyGems installed.  If you have worked with gems before this will look very familiar.

=== Installation pre-requisites

Before you can make use of this gem you will need an Amazon Web Services developer account which you can sign up for at https://aws-portal.amazon.com/gp/aws/developer/registration/index.html.  This account must also be specifically enabled for Amazon EC2 usage.  AWS will provide you with an 'AWS Access Key ID' and a 'Secret Access Key' which will allow you to authenticate any API calls you make and ensure correct billing to you for usage of the service.  Take note of these (and keep them secret!).

=== Installing the gem (Mac OS X / Linux)

  sudo gem install amazon-ec2

=== Installing the gem (Windows)

  gem install amazon-ec2


== Usage Examples

The library exposes one main interface class EC2::Base.  It is through an instance of this class that you will perform all the operations for using the EC2 service including query string header signing.

The public methods on EC2::Base closely mirror the EC2 Query API, and as such the Query API Reference in the EC2 Developer Guide ( http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=84 ) will prove helpful.

=== Ruby script usage example:

Try out the following bit of code.  This should walk through each image returned by a call to #describe_images and print out its key data.  Note in the example below that you cannot walk through the results of the #describe_images call with the '.each' iterator (You'll get errors if you try).  You need to instead walk through the Array of items which are in the 'imagesSet' embedded in the response.  This reflects exactly the XML hierarchy of data returned from EC2 which we parse to Ruby OpenStruct objects (EC2::Response).

	#!/usr/bin/env ruby
	
	require 'rubygems'
	require 'ec2'
	
	ACCESS_KEY_ID = '--YOUR AWS ACCESS KEY ID--'
	SECRET_ACCESS_KEY = '--YOUR AWS SECRET ACCESS KEY--'
	  
	ec2 = EC2::Base.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
	 
	puts "----- listing images owned by 'amazon' -----"
	ec2.describe_images(:owner_id => "amazon").imagesSet.item.each do |image|
	  # OpenStruct objects have members!
	  image.members.each do |member|
	    puts "#{member} => #{image[member]}" 
	  end
	end

=== Ruby on Rails usage example:

<b>config/environment.rb</b>

	# Require the amazon-ec2 gem and make its methods available in your Rails app
	# Put this at the bottom of your environment.rb
	require 'EC2'

<b>app/controllers/my_controller.rb</b>

	[some controller code ...]
	
	ec2 = EC2::Base.new(:access_key_id => "YOUR_AWS_ACCESS_KEY_ID", :secret_access_key => "YOUR_AWS_SECRET_ACCESS_KEY")
	
	# get ALL public images
	@ec2_images = ec2.describe_images().imagesSet.item
	
	# Get info on all public EC2 images created by the Amazon EC2 team.
	@ec2_images_amazon = ec2.describe_images(:owner_id => "amazon").imagesSet.item
	
	[some more controller code ...]

	
<b>app/views/my/index.rhtml</b>

	<h1>EC2 Test#index</h1>
	
	<h1>Sample 1 - debug() view</h1>
	
	<%= debug(@ec2_images_amazon) %>
	
	<h1>Sample 2 - Build a table</h1>
	
	<table border='1'>
	  <tr>
	    <th>image.imageId</th>
	    <th>image.imageLocation</th>
	    <th>image.imageOwnerId</th>
	    <th>image.imageState</th>
	    <th>image.isPublic</th>
	  </tr>
	
	  <% for image in @ec2_images_amazon %>
	    <tr>
	      <td><%=h image.imageId %></td>
	      <td><%=h image.imageLocation %></td>
	      <td><%=h image.imageOwnerId %></td>
	      <td><%=h image.imageState %></td>
	      <td><%=h image.isPublic %></td>
	    </tr>
	  <% end %>
	</table>
	
	<h1>Sample 3 - Iterate</h1>
	
	<% @ec2_images_amazon.each do |image| %>
		<% image.each_pair do |key, value| %>
			<% unless key == 'parent' %>
				<%= "#{key} => #{value}" %><br />
			<% end %>
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

* Capsize : http://capsize.rubyforge.org

== Credits

The original sample code for this library was provided by Amazon Web Services, LLC.  Thanks to them for providing all of us with samples that got this started.

Thanks to Dr. Nic Williams and his great 'NewGem' Ruby Gem Generator.  This "gem" of a Gem helped me package up this code for distribution in a relative flash!  You can find Dr. Nic's NewGem generator at http://newgem.rubyforge.org.

== Contact

Comments, patches, and bug reports are welcome. Send an email to mailto:grempe@nospam@rubyforge.org or use the RubyForge forum for this project.

Enjoy!

Glenn Rempe
