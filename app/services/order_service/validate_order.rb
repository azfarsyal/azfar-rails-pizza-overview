# frozen_string_literal: true

module OrderService
  # To validate the input fields for pizza's order
  class ValidateOrder
    class OrderFieldsInvalid < StandardError; end

    def initialize(promotion_codes:, discount_code:, items:)
      @promotion_codes = promotion_codes
      @discount_code = discount_code
      @items = items
      @error_msgs = []
    end

    def call
      validate_discount_code
      validate_promotion_codes
      validate_pizzas_flavours
      validate_pizzas_sizes
      validate_pizza_ingredients

      raise OrderFieldsInvalid, @error_msgs.uniq if @error_msgs.present?
    end

    private

    def validate_discount_code
      return unless @discount_code.present?

      discount = Discount.find_by(name: @discount_code&.downcase)
      @error_msgs.push("Discount code: '#{@discount_code}' is not available") unless discount.present?
    end

    def validate_promotion_codes
      return unless @promotion_codes.present?

      validate_promotion_codes_duplication
      validate_promotion_codes_availability
    end

    def validate_promotion_codes_duplication
      return if @promotion_codes.length < 2

      duplicate_code = @promotion_codes.group_by { |code| code }
                                       .select { |_key, value| value.size > 1 }
                                       .keys

      return unless duplicate_code.present?

      @error_msgs.push("Duplicate Promotion Codes found for same order: '#{duplicate_code.inspect}'")
    end

    def validate_promotion_codes_availability
      uniq_promo_codes = @promotion_codes.uniq
      available_promotions = Promotion.where(name: uniq_promo_codes.map(&:downcase)).pluck(:name)
      uniq_promo_codes.each do |promo_code|
        next if available_promotions.include?(promo_code.downcase)

        @error_msgs.push("Promotion code: '#{promo_code}' is not available")
      end
    end

    def validate_pizzas_flavours
      return unless @items.present?

      flavor_names = @items.map { |item| item[:flavour]&.downcase }
      available_flavors = Flavour.where(name: flavor_names).pluck(:name)

      @items.each do |item|
        validate_pizza_name_presence(item)
        validate_pizza_flavour_availability(item, available_flavors)
      end
    end

    def validate_pizza_name_presence(item)
      return unless item[:flavour].nil? || item[:flavour].empty?

      @error_msgs.push("Pizza Name is missing for item: #{item.inspect}")
    end

    def validate_pizza_flavour_availability(item, available_flavors)
      return unless item[:flavour].present? && available_flavors.exclude?(item[:flavour]&.downcase)

      @error_msgs.push("Flavour: '#{item[:flavour]}' is not available")
    end

    def validate_pizzas_sizes
      return unless @items.present?

      size_names = @items.map { |item| item[:size]&.downcase }
      available_sizes = Size.where(name: size_names).pluck(:name)

      @items.each do |item|
        validate_pizza_size(item, available_sizes)
      end
    end

    def validate_pizza_size(item, available_sizes)
      if item[:size].nil? || item[:size].empty?
        @error_msgs.push("Pizza Size is missing for item: #{item.inspect}")
      elsif available_sizes.exclude?(item[:size]&.downcase)
        @error_msgs.push("Size: '#{item[:size]}' is not available")
      end
    end

    def validate_pizza_ingredients
      return unless @items.present?

      ingredients = validate_duplicate_ingredients
      return unless ingredients.present?

      validate_available_ingredients(ingredients)
    end

    # Validate duplication of ingredients at the same time
    # in both add and remove keys for a single pizza item
    def validate_duplicate_ingredients
      ingredients = []

      @items.each do |item|
        adding_ings = item[:add] || []
        removing_ings = item[:remove] || []
        ingredients.concat(adding_ings, removing_ings).uniq!
        matched_ings = adding_ings & removing_ings

        next unless matched_ings.present?

        @error_msgs.push("Ingredients can't be added and removed at the same time: #{matched_ings.inspect}")
      end

      ingredients
    end

    def validate_available_ingredients(ingredients)
      available_ingredients = Ingredient.where(name: ingredients.compact.map(&:downcase)).pluck(:name)
      ingredients.each do |ing|
        next if available_ingredients.include?(ing&.downcase)

        @error_msgs.push("Ingredient '#{ing}' is not available to add/remove")
      end
    end
  end
end
