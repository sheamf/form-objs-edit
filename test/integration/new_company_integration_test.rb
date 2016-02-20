require_relative "integration_test_helper"

class NewCompanyIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    visit new_company_path
  end

  test "visit new company page" do
    assert page.has_content?("Add a New Company + Offices")
  end

  test "failed form submit" do
    fill_in_company_info(company_opts)
    fill_in_office_info(office_opts(city: nil))
    
    failed_submission_submit
  end

  test "successful form submit" do
    fill_in_new_company_default_info
      
    successful_submission_test(:create)
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

    fill_in_office_info(office_opts({ selector: last_office_row_fieldset }))

    successful_submission_test(:create)

    Capybara.use_default_driver
  end

  test "successful submit after removing incomplete office row" do
    Capybara.current_driver = Capybara.javascript_driver

    failed_creation_multiple_offices

    within last_office_row_fieldset do
      click_button 'Remove'
    end

    successful_submission_test(:create)    

    Capybara.use_default_driver
  end

  private

  def fill_in_company_info(opts = {})
    within('div.company-details') do
      fill_in 'Name', with: opts[:name]
      fill_in 'Employee count', with: opts[:employee_count]
    end
  end

  def fill_in_new_company_default_info
    fill_in_company_info(company_opts)
    fill_in_office_info(office_opts)
  end

  def failed_creation_multiple_offices
    fill_in_new_company_default_info

    click_button "Add Another Office"

    fill_in_office_info(office_opts({ selector: last_office_row_fieldset, city: nil }))

    failed_submission_submit
  end
end