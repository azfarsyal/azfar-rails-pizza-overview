# frozen_string_literal: true

# This class represents available ingredients for pizza.
class Ingredient < ApplicationRecord
  has_many :pizza_ingredients, dependent: :destroy
  has_many :pizzas, through: :pizza_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :multiplier, presence: true, numericality: { greater_than_or_equal_to: 0.1 }
end
