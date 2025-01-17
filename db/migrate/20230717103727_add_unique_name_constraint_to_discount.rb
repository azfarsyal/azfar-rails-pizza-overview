class AddUniqueNameConstraintToDiscount < ActiveRecord::Migration[7.0]
  def change
    add_index :discounts, :name, unique: true
  end
end
