class EditCompanyForm < CompanyForm

  attr_reader :company, :employee_count

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
    @office_rows.each { |office_row| office_row.persist! }
    @company.update_attributes!(name: name, employee_count: employee_count)
  end

  def extract_params(params) # why is params passed in if I'm just grabbing the ivar set in #super?
    super

    existing_office_params = @office_params.select { |k, v| v[:id].present? }
    new_office_params = @office_params.select { |k, v| v[:id].blank? }

    @office_rows = office_rows.select { |row| row.persisted? } # remove NewOfficeRow instances

    @office_rows.each do |office_row|
      params = existing_office_params.select { |k, v| v[:id] == office_row.office.id.to_s } # could just use @office_params and eliminate
      params = params.values.inject(:reduce)                                                # the existing_... select bit, I think
      office_row.extract_params(params)
    end

    new_office_params.each do |k, v|
      @office_rows << NewOfficeRow.new(v)
    end
  end

  class EditOfficeRow < OfficeRow

    attr_reader :company, :office, :id

    def initialize(office)
      @office = office
      @company = office.company
      @id = office.id # used for the hidden_field, just get from row.office in view?
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

    def persist!
      @office.update_attributes!(name: name, city: city, state: state, employee_count: employee_count)
    end
  end
end