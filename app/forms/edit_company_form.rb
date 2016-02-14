class EditCompanyForm < CompanyForm

  attr_reader :company

  def initialize(company)
    @company = company
    @name = company.name
    @employee_count = company.employee_count
  end

  def office_rows
    @office_rows ||= company.offices.map { |office| EditOfficeRow.new(office) }
  end

  def persisted?
    true
  end

  def persist!
    @company.update_attributes!(name: name, employee_count: employee_count)
    @office_rows.each { |office_row| office_row.save! }
  end

  def extract_params(params)
    super

    @office_rows = office_rows.each do |office_row|
      office_params = @office_params[office_row.id.to_s]
      office_row.extract_params(office_params)
    end
  end

  class EditOfficeRow < OfficeRow

    attr_reader :office, :id

    def initialize(office)
      @office = office
      @id = office.id
      @name = office.name
      @city = office.city
      @state = office.state
      @employee_count = office.employee_count
    end

    def persisted?
      true
    end

    def extract_params(params)
      @name = params[:name]
      @city = params[:city]
      @state = params[:state]
      @employee_count = params[:employee_count]
    end

    def save!
      @office.update_attributes!(name: name, city: city, state: state, employee_count: employee_count)
    end
  end
end