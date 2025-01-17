# frozen_string_literal: true

# This class represents selected promotions for an order.
class OrderPromotion < ApplicationRecord
  belongs_to :order
  belongs_to :promotion
end
