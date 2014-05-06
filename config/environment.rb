# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Saaswiki::Application.initialize!

#Need to add this for rspec (the sign up portion of testing)
Rails.application.routes.default_url_options[:host] = 'localhost:3000'
