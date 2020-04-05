class Year < ApplicationRecord
	belongs_to :calendar
	has_many :month, dependent: :destroy
end
