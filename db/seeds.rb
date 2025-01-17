# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Flavour.find_or_create_by(name: 'margherita', base_price: 5)
salami_flv = Flavour.find_or_create_by(name: 'salami', base_price: 6)
Flavour.find_or_create_by(name: 'tonno', base_price: 8)

Ingredient.find_or_create_by(name: 'onions', multiplier: 1)
Ingredient.find_or_create_by(name: 'cheese', multiplier: 2)
Ingredient.find_or_create_by(name: 'olives', multiplier: 2.5)

small = Size.find_or_create_by(name: 'small', multiplier: 0.7)
Size.find_or_create_by(name: 'medium', multiplier: 1)
Size.find_or_create_by(name: 'large', multiplier: 1.3)

Discount.find_or_create_by(name: 'saves5', percentage: 5)
Discount.find_or_create_by(name: 'saves10', percentage: 10)
Discount.find_or_create_by(name: 'saves25', percentage: 25)

Promotion.find_or_create_by(name: '2for1-salami-small', charge_for_item: 1, serving_count: 2,
                            flavour_id: salami_flv.id, size_id: small.id)

order_1_items = [
  { flavour: 'tonno', size: 'large' }
]

order_2_items = [
  { flavour: 'margherita', size: 'large',
    add: %w[onions cheese olives] },
  { flavour: 'tonno', size: 'medium',
    remove: %w[onions olives] },
  { flavour: 'margherita', size: 'small' }
]

order_3_items = [
  { flavour: 'salami', size: 'medium',
    add: ['onions'],
    remove: ['cheese'] },
  { flavour: 'salami', size: 'small' },
  { flavour: 'salami', size: 'small' },
  { flavour: 'salami', size: 'small' },
  { flavour: 'salami', size: 'small',
    add: ['olives'] }
]

OrderService::CreateOrder.new(items: order_1_items).call
OrderService::CreateOrder.new(items: order_2_items).call
OrderService::CreateOrder.new(items: order_3_items, promotion_codes: ['2for1-salami-small'],
                              discount_code: 'saves5').call
