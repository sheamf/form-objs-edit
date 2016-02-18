class NewCompanyForm < CompanyForm

  def persisted?
    false
  end

  def office_rows
    @office_rows ||= [NewOfficeRow.new] # uhhhh...
  end

  def persist!
    @company = Company.new(name: name, employee_count: employee_count)

    @office_rows.each do |office_row|
      office = office_row.persist!
      @company.offices << office
    end

    @company.save!
  end

  def extract_params(params)
    super

    @office_rows = @office_params.map do |k, office_attrs|
      NewOfficeRow.new(office_attrs)
    end
  end

end