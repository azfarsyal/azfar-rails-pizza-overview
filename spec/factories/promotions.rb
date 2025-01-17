# frozen_string_literal: true

FactoryBot.define do
  factory :promotion do
    name { 'Sample Promotion' }
    charge_for_item { 1 }
    serving_count { 2 }
  end
end
