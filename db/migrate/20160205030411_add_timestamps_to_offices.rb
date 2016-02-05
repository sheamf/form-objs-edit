class AddTimestampsToOffices < ActiveRecord::Migration
  def change
    add_column :offices, :created_at, :datetime
    add_column :offices, :updated_at, :datetime
  end
end
