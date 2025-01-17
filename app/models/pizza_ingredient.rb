# frozen_string_literal: true

# This class represents selected ingredients for a pizza in an order.
class PizzaIngredient < ApplicationRecord
  belongs_to :pizza
  belongs_to :ingredient

  validates :added, inclusion: { in: [true, false] }

  scope :added_status, ->(status) { where(added: status) }
end
