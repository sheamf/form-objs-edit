require_relative "integration_test_helper"

class NewCompanyIntegrationTest < ActionDispatch::IntegrationTest

  def setup
  end

  test "visit new company page" do
    visit new_company_path

    assert page.has_content?("Add a New Company + Offices")
  end

  test "failed submit" do
    visit new_company_path

    fill_in_company_info(company_opts)
    fill_in_office_info(office_opts(city: nil))
    
    click_button 'Save'

    assert page.has_content? "can't be blank"
  end

  test "successful submit" do
    fill_in_new_company_default_info
    
    click_button 'Save'
  
    assert_company_created
  end

  test "failed submit with multiple offices" do
    Capybara.current_driver = Capybara.javascript_driver

    failed_creation_multiple_offices

    Capybara.use_default_driver
  end

  test "successful submit with multiple offices" do
    Capybara.current_driver = Capybara.javascript_driver

    fill_in_new_company_default_info

    click_button "Add Another Office"

    fill_in_office_info(office_opts({ selector: new_office_row_fieldset }))

    click_button 'Save'

    assert_company_created

    Capybara.use_default_driver
  end

  test "successful submit after removing incomplete office row" do
    Capybara.current_driver = Capybara.javascript_driver

    failed_creation_multiple_offices

    within new_office_row_fieldset do
      click_button 'Remove'
    end

    click_button 'Save'

    assert_company_created    

    Capybara.use_default_driver

  end

  private

  def fill_in_company_info(opts = {})
    within('div.company-details') do
      fill_in 'Name', with: opts[:name]
      fill_in 'Employee count', with: opts[:employee_count]
    end
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

  def company_opts(opts = {})
    { name: 'LolCo', employee_count: 1 }.merge(opts)
  end

  def office_opts(opts = {})
    { name: 'Office1', city: 'Muskogee', state: 'OK', employee_count: 1 }.merge(opts)
  end

  def fill_in_new_company_default_info
    visit new_company_path

    fill_in_company_info(company_opts)
    fill_in_office_info(office_opts)
  end

  def assert_company_created
    assert_equal companies_path, page.current_path
    assert page.has_content? 'Company successfully created.'
    assert page.has_content? company_opts[:name]
  end

  def new_office_row_fieldset
    count = page.all('div.office-row-fieldset').size
    "#office-#{count - 1}"
  end

  def failed_creation_multiple_offices
    fill_in_new_company_default_info

    click_button "Add Another Office"

    fill_in_office_info(office_opts({ selector: new_office_row_fieldset, city: nil }))

    click_button 'Save'

    assert page.has_content? "can't be blank"
  end
end