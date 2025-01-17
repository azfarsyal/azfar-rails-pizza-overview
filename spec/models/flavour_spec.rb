# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flavour, type: :model do
  describe 'validations' do
    subject { build(:flavour) } # Assuming you're using FactoryBot for test data creation

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:base_price) }
    it { should validate_numericality_of(:base_price).is_greater_than_or_equal_to(2) }
  end

  describe 'associations' do
    it { should have_many(:pizzas).dependent(:destroy) }
    it { should have_many(:promotions).dependent(:destroy) }
  end
end
