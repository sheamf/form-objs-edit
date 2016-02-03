class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @form = CompanyForm.new
  end

  def create
    form = CompanyForm.new

    if form.submit(params[:company_form])
      redirect_to companies_path, notice: "Company successfully created."
    else
      @form = form
      render :new
    end
  end

end