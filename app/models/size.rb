# frozen_string_literal: true

# This class represents the available sizes for pizza.
class Size < ApplicationRecord
  has_many :pizzas, dependent: :destroy
  has_many :promotions, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :multiplier, presence: true, numericality: { greater_than_or_equal_to: 0.1 }
end
