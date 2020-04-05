class Day < ApplicationRecord
	belongs_to :month
	has_many :slot, dependent: :destroy
end
