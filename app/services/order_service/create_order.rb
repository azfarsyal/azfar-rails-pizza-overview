# frozen_string_literal: true

module OrderService
  # To create the pizza order
  class CreateOrder
    def initialize(
      items:, status: :pending,
      promotion_codes: [],
      discount_code: nil
    )
      @status = status
      @promotion_codes = promotion_codes
      @discount_code = discount_code
      @items = items
      @order = nil
    end

    def call
      ActiveRecord::Base.transaction do
        validate_order
        create_order
        create_order_promotions
        create_pizza
        total_price = calculate_total_price

        @order.update!(total_price:)
      end
    end

    private

    def validate_order
      OrderService::ValidateOrder.new(
        promotion_codes: @promotion_codes,
        discount_code: @discount_code,
        items: @items
      ).call
    end

    def calculate_total_price
      OrderService::CalculateTotalPrice.new(
        order_id: @order.id
      ).call
    end

    def create_order
      discount = Discount.find_by(name: @discount_code)
      order_attributes = { status: @status, total_price: 0 }
      order_attributes[:discount_id] = discount.id if discount.present?
      @order = Order.create!(order_attributes)
    end

    def create_order_promotions
      @promotion_codes.each do |promo_code|
        promo = Promotion.find_by(name: promo_code)
        OrderPromotion.create!(order: @order, promotion: promo)
      end
    end

    def create_pizza
      @items.each do |item|
        flavour = Flavour.find_by(name: item[:flavour]&.downcase)
        size = Size.find_by(name: item[:size]&.downcase)
        pizza_item = Pizza.create!(order: @order, flavour:, size:)

        modify_pizza_ingredient(added: true, pizza_id: pizza_item&.id, ingredients: item[:add])
        modify_pizza_ingredient(added: false, pizza_id: pizza_item&.id, ingredients: item[:remove])
      end
    end

    def modify_pizza_ingredient(added:, pizza_id:, ingredients:)
      return unless ingredients.present?

      ingredients.each do |ing_name|
        ingredient = Ingredient.find_by(name: ing_name)
        PizzaIngredient.create!(added:, ingredient:, pizza_id:) if ingredient.present?
      end
    end
  end
end
