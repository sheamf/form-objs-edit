class CompanyForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :name, :employee_count

  with_options presence: true do |required|
    required.validates :name
    required.validates :employee_count
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Company")
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
      
  def extract_params(params)
    @name = params[:name]
    @employee_count = params[:employee_count]
    @office_params = params[:office_rows]
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

  end
end