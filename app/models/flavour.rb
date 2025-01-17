# frozen_string_literal: true

# This class represents available flavours for pizza.
class Flavour < ApplicationRecord
  has_many :pizzas, dependent: :destroy
  has_many :promotions, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 2 }
end
