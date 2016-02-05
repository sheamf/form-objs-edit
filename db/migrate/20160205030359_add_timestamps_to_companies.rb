class AddTimestampsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :created_at, :datetime
    add_column :companies, :updated_at, :datetime
  end
end
