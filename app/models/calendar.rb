class Calendar < ApplicationRecord
	belongs_to :user
	has_many :year, dependent: :destroy
end
