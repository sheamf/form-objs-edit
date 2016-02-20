require_relative "integration_test_helper"

class NewCompanyIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    @company = companies(:company)
    @office1 = offices(:office1)
    @office2 = offices(:office2)

    visit edit_company_path(company)
  end

  test "visit edit company page" do
    assert page.has_content?("Edit #{company.name} + Offices")
  end

  test "failed company edit" do    
    within last_office_row_fieldset do
      fill_in 'Name', with: nil
    end

    failed_submission_submit
  end

  test "successful company edit" do    
    within last_office_row_fieldset do
      fill_in 'Name', with: 'new office name'
    end

    successful_submission_test(:update)
  end

  test "failed edit with new office row" do
    click_button "Add Another Office"

    fill_in_office_info(office_opts({ selector: last_office_row_fieldset, city: nil }))

    failed_submission_submit
  end

  test "successful edit with new office row" do
    click_button "Add Another Office"

    fill_in_office_info(office_opts({ selector: last_office_row_fieldset }))

    successful_submission_test(:update)
  end

  private

  attr_reader :company, :office1, :office2

end
