class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :name
      t.string :city
      t.string :state
      t.integer :employee_count
      t.integer :company_id
    end
  end
end
