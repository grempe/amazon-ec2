=README.txt : Amazon Elastic Compute Cloud (EC2) Ruby Gem

AWS EC2 is an interface library that can be used to interact
with the Amazon EC2 system.  The library exposes one main interface class, 
'AWSAuthConnection'.  This class performs all the operations for using 
the EC2 service including header signing.

==Important note about this project:
Please note that I am packaging this sample code up as a service to the 
Ruby community and do not plan to be actively maintaining this code 
on a regular basis.  If you can contribute documentation or additional tests as
Subversion patch files I will be happy to incorporate those directly into the library.
Alternatively, if you are interested in becoming a contributing developer with checkin
privileges on this source code please feel free to contact me.

==RubyForge Project Info
This project is hosted on the RubyForge project server.  You can find the project at:

  http://amazon-ec2.rubyforge.org/
  http://rubyforge.org/projects/amazon-ec2/

Please actively report any bugs that you find using the bug tracker found on the RubyForge site.  Please submit any patches as well through that mechanism.  If you feel you want to help contribute to the project please contact me at:

  grempe @no spam@ rubyforge.org

==Prerequisites:

An Amazon Web Services Developer account which is also signed up for Amazon EC2.  
You will need the AWS Access Key ID and Secret Access Key that they provide when you
sign up.


==Installation:

The specific installation may vary according to your operation system.  Some examples are below.

Linux/Mac OS X:

  sudo gem install amazon-ec2

Windows:

  gem install amazon-ec2


==Usage:

The public methods on AWSAuthConnection closely mirror the EC2 Query API, and
as such the Query API Reference in the EC2 Developer Guide should be consulted.

===Example Code Usage (Stand-alone Ruby Application):

  #!/usr/bin/env ruby
  require 'rubygems'
  require_gem 'amazon-ec2'
  AWS_ACCESS_KEY_ID = '--YOUR AWS ACCESS KEY ID--'
  AWS_SECRET_ACCESS_KEY = '--YOUR AWS SECRET ACCESS KEY--'
  conn = EC2::AWSAuthConnection.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
  puts "----- listing images -----"
  puts conn.describe_images()


An example client is provided as a starting point in this Gem installation which 
you may consult for a few more detailed usage examples.

  examples/ec2-example.rb


===Example Code Usage (Ruby on Rails Application):

  config/environment.rb:
  ...
  # Include Amazon Web Services EC2 library gem
  require_gem 'amazon-ec2'

  app/controllers/your_controller.rb:
  conn = EC2::AWSAuthConnection.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
  
  # The .parse method gives you back an array of values you can use in your view
  @ec2_images = conn.describe_images().parse
  
  -- OR with some params (in this case specific owner ID's) --

  @ec2_images_mine = ec2.describe_images([],["522821470517"],[]).parse
  
  
  app/views/your_view.rhtml:
  
  <%= debug(@ec2_images) %>
  
  -- OR --
  
  <% @ec2_images.each do |image| %>
    <% image.each_with_index do |value, index| %>
      <%= "#{index} => #{value}" %><br />
    <% end %>
  <% end %>

  -- OR --

  <table>
    <tr>
      <th>Id</th>
      <th>Location</th>
      <th>Owner</th>
      <th>State</th>
      <th>Public?</th>
    </tr>
  
  <% for ec2_image in @ec2_images %>
    <tr>
      <td><%=h ec2_image[1] %></td>
      <td><%=h ec2_image[2] %></td>
      <td><%=h ec2_image[3] %></td>
      <td><%=h ec2_image[4] %></td>
      <td><%=h ec2_image[5] %></td>
    </tr>
  <% end %>
  </table>


==To Do:

* As provided by Amazon, this library has nearly non-existent error handling.  
  All errors from lower libraries are simply passed up.  The response code in 
  the returned object needs to be checked after each request to verify 
  whether the request succeeded.
* Documentation - The code is almost devoid of documentation.  RDoc comments in 
  the code would be very useful.
* Automated Unit Tests - There are currently no unit tests for this code.  
  A suite of tests to help exercise the code would greatly improve our confidence.


==Credits:

* The original sample code for this library was provided by Amazon Web Services, LLC.  
  Thanks to them for providing the samples that got this started.  They took the wind out 
  of the sails of my own version of this library (which was maybe 75% complete), but they 
  probably saved me some hair that otherwise would have suffered self-inflicted removal.

* Thanks to Dr. Nic Williams and his great 'newgem' Ruby Gem Generator which can be found 
  at http://drnicwilliams.com/2006/10/11/generating-new-gems.  This helped me package up 
  this code for distribution in a flash.


=Original AWS README for this code (12/13/2006)

http://developer.amazonwebservices.com/connect/entry.jspa?externalID=553

This is one of a collection of interface libraries that can be used to interact
with the Amazon EC2 system in a number of different languages.  They each
expose one main interface class, AWSAuthConnection.  This performs all the
operations using the appropriate libraries for the language, including header
signing.


==Usage:

The public methods on AWSAuthConnection closely mirror the EC2 Query API, and
as such the Query API Reference in the EC2 Developer Guide should be consulted.

An example client is provided as a starting point.


==Prerequisites:

An Amazon Web Services Developer account signed up for Amazon EC2.


==Limitations:

These libraries have nearly non-existent error handling.  All errors from lower
libraries are simply passed up.  The response code in the returned object needs
to be checked after each request to verify whether the request succeeded.

It is our intention that these libraries act as a starting point for future
development.  They are meant to show off the various operations and provide an
example of how to negotiate the authentication process.

This software code is made available "AS IS" without warranties of any kind.
You may copy, display, modify and redistribute the software code either by
itself or as incorporated into your code; provided that you do not remove any
proprietary notices.  Your use of this software code is at your own risk and
you waive any claim against Amazon Web Services LLC or its affiliates with
respect to your use of this software code. (c) 2006 Amazon Web Services LLC or
its affiliates.  All rights reserved.
