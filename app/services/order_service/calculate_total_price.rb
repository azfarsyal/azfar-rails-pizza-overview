# frozen_string_literal: true

module OrderService
  # To calculate the total price of pizzas' order
  class CalculateTotalPrice
    def initialize(order_id:)
      @order = Order.find(order_id)
      @total_price = 0
    end

    def call
      calculate_price_by_size_and_ingredients
      calculate_price_after_promotions
      calculate_price_after_discount

      @total_price.round(2)
    end

    private

    def calculate_price_by_size_and_ingredients
      @order.pizzas.each do |pizza|
        base_price = pizza.flavour.base_price
        added_pizza_ingredients = pizza.pizza_ingredients.added_status(true)

        added_ingredients_total_price = calculate_price_by_ingredients(base_price, added_pizza_ingredients)
        price_by_size = base_price * pizza.size.multiplier

        pizza_total_price = price_by_size + added_ingredients_total_price
        @total_price += pizza_total_price
      end
    end

    def calculate_price_by_ingredients(base_price, added_pizza_ingredients)
      added_ingredients_total_price = 0

      added_pizza_ingredients.each do |pizza_ing|
        ing_price = base_price * pizza_ing.ingredient.multiplier
        added_ingredients_total_price += ing_price
      end

      added_ingredients_total_price
    end

    def calculate_price_after_promotions
      @order.promotions.each do |promo|
        ordered_pizzas_having_promo = valid_pizzas_for_promo(promo)

        next if ordered_pizzas_having_promo.empty?

        charge_for = charge_for_promo_pizza_count(promo, ordered_pizzas_having_promo)
        total_free_pizzas_cost = total_free_pizzas_cost(ordered_pizzas_having_promo, charge_for)

        @total_price -= total_free_pizzas_cost
      end
    end

    def valid_pizzas_for_promo(promo)
      @order.pizzas.where(
        flavour_id: promo.flavour.id,
        size_id: promo.size.id
      )
    end

    # To calculate the number of pizzas to pay out of all available pizzas having promo
    def charge_for_promo_pizza_count(promo, ordered_pizzas_having_promo)
      promo_pizzas_count = ordered_pizzas_having_promo.length
      applicable_promo_count = promo_pizzas_count - (promo_pizzas_count % promo.serving_count)

      charge_for = (applicable_promo_count / promo.serving_count) * promo.charge_for_item
      charge_for + (promo_pizzas_count - applicable_promo_count)
    end

    # To calulate cost of all free pizzas in an order
    def total_free_pizzas_cost(ordered_pizzas_having_promo, charge_for)
      free_promo_pizza_count = ordered_pizzas_having_promo.length - charge_for
      base_price = ordered_pizzas_having_promo[0].flavour.base_price
      size_multiplier = ordered_pizzas_having_promo[0].size.multiplier

      free_per_pizza_cost = base_price * size_multiplier
      free_per_pizza_cost * free_promo_pizza_count
    end

    def calculate_price_after_discount
      return unless @order.discount.present?

      percentage = @order.discount.percentage / 100.0
      discounted_price = @total_price * percentage
      @total_price -= discounted_price
    end
  end
end
