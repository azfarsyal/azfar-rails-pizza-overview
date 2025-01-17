# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'
require 'rails-controller-testing'

RSpec.describe 'Orders', type: :request do
  describe 'GET #index' do
    it 'assigns @orders with pending orders' do
      order1 = create(:order, status: :pending)
      order2 = create(:order, status: :completed)

      get orders_path

      expect(assigns(:orders)).to include(order1)
      expect(assigns(:orders)).not_to include(order2)
    end
  end

  describe 'PATCH #update' do
    let(:update_params) { { order: { status: :completed } } }

    it 'updates order status to completed and completed_at to current time' do
      order = create(:order, status: :pending)

      patch order_path(order), params: update_params

      expect(response).to redirect_to(root_path)
      order.reload
      expect(order.status).to eq('completed')
      expect(order.completed_at).to be_within(1.minute).of(DateTime.current)
    end

    it 'redirects to root_path with a success notice if order is updated successfully' do
      order = create(:order, status: :pending)

      patch order_path(order), params: update_params

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Order status updated successfully.')
    end

    it 'redirects to root_path with an alert if order is not found' do
      patch order_path(-1), params: update_params

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Record not found.')
    end

    it 'redirects to root_path with an alert if order status update fails' do
      order = create(:order, status: :pending)
      allow_any_instance_of(Order).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

      patch order_path(order), params: update_params

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Failed to update record.')
    end
  end
end

# rubocop:enable Metrics/BlockLength
