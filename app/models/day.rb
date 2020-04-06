class Day < ApplicationRecord
	belongs_to :month
	has_many :slot, dependent: :destroy
  validates :name, presence: true, length: {minimum: 1, maximum: 2}
end
