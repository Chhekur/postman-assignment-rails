class Year < ApplicationRecord
	belongs_to :calendar
	has_many :month, dependent: :destroy
  validates :name, presence: true, length: {minimum: 4, maximum: 4}
end
