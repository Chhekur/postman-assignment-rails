class Month < ApplicationRecord
	belongs_to :year
	has_many :day, dependent: :destroy
  validates :name, presence: true, length: {minimum: 1, maximum: 2}
end
