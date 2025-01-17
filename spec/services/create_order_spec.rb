# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe OrderService::CreateOrder do
  let(:valid_flavour) { create(:flavour, name: 'pepperoni', base_price: 10) }
  let(:valid_size) { create(:size, name: 'medium', multiplier: 1) }
  let(:valid_promotion) { create(:promotion, name: '2for1', flavour: valid_flavour, size: valid_size) }
  let(:valid_discount) { create(:discount, name: 'saves20', percentage: 10) }
  let(:valid_promotion_codes) { [valid_promotion.name.to_s] }
  let(:valid_discount_code) { valid_discount.name.to_s }
  let(:order_status) { 'pending' }

  subject(:create_order) do
    described_class.new(
      items: valid_items,
      promotion_codes: valid_promotion_codes,
      discount_code: valid_discount_code,
      status: order_status
    )
  end

  describe '#call' do
    context 'when the order is valid' do
      let(:valid_ingredient) { create(:ingredient, name: 'mushroom', multiplier: 2) }
      let(:valid_items) { [{ flavour: valid_flavour.name, size: valid_size.name, add: [valid_ingredient.name.to_s] }] }

      it 'creates a new order with the correct attributes' do
        expect { create_order.call }.to change { Order.count }.by(1)

        order = Order.last
        expect(order.status).to eq(order_status)
        expect(order.total_price).not_to be_zero
        expect(order.discount).to eq(Discount.find_by(name: valid_discount_code))
      end

      it 'creates the associated pizzas and pizza ingredients' do
        expect do
          create_order.call
        end.to change { Order.count }.by(1)
           .and change { Pizza.count }.by(1)
           .and change { PizzaIngredient.count }.by(1)

        pizza = Pizza.last
        expect(pizza.order).to eq(Order.last)
        expect(pizza.flavour).to eq(Flavour.find_by(name: valid_items[0][:flavour].downcase))
        expect(pizza.size).to eq(Size.find_by(name: valid_items[0][:size].downcase))

        pizza_ingredient = PizzaIngredient.last
        expect(pizza_ingredient.pizza).to eq(pizza)
        expect(pizza_ingredient.ingredient).to eq(Ingredient.find_by(name: valid_items[0][:add][0].downcase))
        expect(pizza_ingredient.added).to be_truthy
      end

      it 'calculates and updates the total price for the order' do
        create_order.call
        order = Order.last

        expect(order.total_price).to eq(27.0)
      end

      it 'creates order promotions' do
        expect { create_order.call }.to change { OrderPromotion.count }.by(1)

        order_promotion = OrderPromotion.last
        expect(order_promotion.order).to eq(Order.last)
        expect(order_promotion.promotion).to eq(Promotion.find_by(name: valid_promotion_codes[0].downcase))
      end
    end

    context 'when the order has invalid data' do
      let(:invalid_items) { [{ flavour: '', size: 'large', add: ['mushrooms'], remove: ['olives'] }] }

      it 'raises OrderFieldsInvalid error if the order data is invalid' do
        invalid_order = described_class.new(
          items: invalid_items,
          promotion_codes: valid_promotion_codes,
          discount_code: valid_discount_code,
          status: order_status
        )

        expect { invalid_order.call }.to raise_error(OrderService::ValidateOrder::OrderFieldsInvalid)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
