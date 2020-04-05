class Month < ApplicationRecord
	belongs_to :year
	has_many :day, dependent: :destroy
end
