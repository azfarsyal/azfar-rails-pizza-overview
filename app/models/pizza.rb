# frozen_string_literal: true

# This class represents a purchased item i.e Pizza.
class Pizza < ApplicationRecord
  belongs_to :order
  belongs_to :flavour
  belongs_to :size

  has_many :pizza_ingredients, dependent: :destroy
  has_many :ingredients, through: :pizza_ingredients
end
