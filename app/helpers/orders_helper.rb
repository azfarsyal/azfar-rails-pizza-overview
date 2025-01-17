# frozen_string_literal: true

# Helper methods for Order Views
module OrdersHelper
  def formatted_date_time(datetime)
    datetime.strftime('%B %d, %Y %H:%M')
  end

  def display_promotions(promotions)
    promotions&.pluck(:name)&.join(', ')
  end

  def display_pizza_ingredients(pizza_ingredients)
    pizza_ingredients.map { |pizza_ing| pizza_ing.ingredient.name&.capitalize }.join(', ') if pizza_ingredients.present?
  end
end
