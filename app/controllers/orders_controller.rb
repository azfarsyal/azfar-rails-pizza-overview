# frozen_string_literal: true

# Contoller for the order routes
class OrdersController < ApplicationController
  before_action :set_order, only: [:update]

  def index
    @orders = Order.pending.includes(:promotions, :discount, pizzas: { pizza_ingredients: :ingredient })
  end

  def update
    @order.update!(order_params)

    redirect_to root_path, notice: I18n.t('orders.update_success')
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status).merge(completed_at: DateTime.current)
  end
end
