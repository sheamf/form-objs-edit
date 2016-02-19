# require "test_helper"
require "rack_session_access/capybara"
require "capybara/rails"
require 'capybara/poltergeist'

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
 
  def self.connection
    @@shared_connection || retrieve_connection
  end
end
 
# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,  :inspector => true)
end

Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest

  include Capybara::DSL



end