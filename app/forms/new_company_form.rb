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
      office = office_row.save!
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

  class NewOfficeRow < OfficeRow

    def initialize(params = {})
      @name = params[:name]
      @city = params[:city]
      @state = params[:state]
      @employee_count = params[:employee_count]
    end

    def persisted?
      false
    end

    def save!
      Office.create!(name: name, city: city, state: state, employee_count: employee_count)
    end
  end
end