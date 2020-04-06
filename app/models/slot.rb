class Slot < ApplicationRecord
	belongs_to :day
  validates :start_time, presence: true, length: {minimum: 1, maximum: 2}
  validates :end_time, presence: true, length: {minimum: 1, maximum: 2}
end
