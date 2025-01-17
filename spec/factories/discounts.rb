# frozen_string_literal: true

FactoryBot.define do
  factory :discount do
    name { 'saves10' }
    percentage { 10 }
  end
end
