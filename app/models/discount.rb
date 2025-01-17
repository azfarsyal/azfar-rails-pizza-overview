# frozen_string_literal: true

# This class represents a discount that can be applied to an order.
class Discount < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :percentage, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
end
