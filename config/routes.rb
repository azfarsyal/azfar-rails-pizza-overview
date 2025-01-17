# frozen_string_literal: true

Rails.application.routes.draw do
  root 'orders#index'

  resources :orders, only: [:index] do
    member { patch :update }
  end
end
