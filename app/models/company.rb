class Company < ActiveRecord::Base

  has_many :offices, dependent: :destroy

end