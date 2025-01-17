class AddUniqueNameConstraintToPromotion < ActiveRecord::Migration[7.0]
  def change
    add_index :promotions, :name, unique: true
  end
end
