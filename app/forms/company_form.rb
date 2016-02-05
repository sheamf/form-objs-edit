class CompanyForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :name, :employee_count

  with_options presence: true do |required|
    required.validates :name
    required.validates :employee_count
  end

  def persisted?
    false
  end

  def office_rows
    @office_rows ||= [OfficeRow.new] # uhhhh...
  end

  def valid?
    validate_rows = @office_rows.all?(&:valid?)
    validate_form = super()
    validate_rows && validate_form
  end

  def submit(params)
    extract_params(params)
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persist!
    @company = Company.new(name: name, employee_count: employee_count)

    @office_rows.each do |office_row|
      office = create_office(office_row)
      @company.offices << office
    end

    @company.save!
  end
      
  def extract_params(params)
    @name = params[:name]
    @employee_count = params[:employee_count]
    office_params = params[:office_rows]

    @office_rows = office_params.map do |k, office_attrs|
      OfficeRow.new(office_attrs)
    end
  end

  def create_office(office_row)
    office_row.save!
  end

  class OfficeRow

    attr_accessor :name, :city, :state, :employee_count

    include ActiveModel::Validations

    with_options presence: true do |required|
      required.validates :name 
      required.validates :city 
      required.validates :state 
      required.validates :employee_count
    end

    def initialize(params = {})
      @name = params[:name]
      @city = params[:city]
      @state = params[:state]
      @employee_count = params[:employee_count]
    end

    def save!
      Office.create!(name: name, city: city, state: state, employee_count: employee_count)
    end
  end
end