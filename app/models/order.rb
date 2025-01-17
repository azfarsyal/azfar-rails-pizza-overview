# frozen_string_literal: true

# This class represents an order that can be placed for a final product i.e. Pizza.
class Order < ApplicationRecord
  belongs_to :discount, optional: true

  has_many :pizzas, dependent: :destroy
  has_many :order_promotions, dependent: :destroy
  has_many :promotions, through: :order_promotions

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  enum status: {
    pending: 0,
    completed: 1
  }
end
