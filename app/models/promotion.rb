# frozen_string_literal: true

# # This class represents Promotion for Pizza.
class Promotion < ApplicationRecord
  belongs_to :flavour
  belongs_to :size

  has_many :order_promotions, dependent: :destroy
  has_many :orders, through: :order_promotions

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :charge_for_item, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :serving_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :serving_count_greater_than_charge_for_item

  private

  def serving_count_greater_than_charge_for_item
    return unless serving_count.present? && charge_for_item.present? && serving_count <= charge_for_item

    errors.add(:serving_count, 'must be greater than charge_for_item')
  end
end
