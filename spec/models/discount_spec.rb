# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    subject { build(:discount) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:percentage) }
    it {
      should validate_numericality_of(:percentage)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    }
  end

  describe 'associations' do
    it { should have_many(:orders) }
  end
end
