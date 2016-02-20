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

  def last_office_row_fieldset
    count = page.all('div.office-row-fieldset').size
    "#office-#{count - 1}"
  end

  def company_opts(opts = {})
    { name: 'LolCo', employee_count: 1 }.merge(opts)
  end

  def office_opts(opts = {})
    { name: 'Office1', city: 'Muskogee', state: 'OK', employee_count: 1 }.merge(opts)
  end

  def fill_in_office_info(opts = {})
    selector = opts.fetch(:selector, 'div.office-row-fieldset')
    
    within(selector) do
      fill_in 'Name', with: opts[:name]
      fill_in 'City', with: opts[:city]
      fill_in 'State', with: opts[:state]
      fill_in 'Employee count', with: opts[:employee_count]
    end
  end

  def successful_submission_test(action_verb)
    click_button 'Save'

    action = action_verb.verb.conjugate(tense: :past, aspect: :perfective)

    assert_equal companies_path, page.current_path
    assert page.has_content? "Company successfully #{action}."
    assert page.has_content? company_opts[:name]
  end

  def failed_submission_submit
    click_button 'Save'

    assert page.has_content? "can't be blank"
  end
end