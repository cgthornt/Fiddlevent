# Load the rails application
require File.expand_path('../application', __FILE__)

Mime::Type.register_alias "text/html", :ajax

# Initialize the rails application
Fiddlevent::Application.initialize!
