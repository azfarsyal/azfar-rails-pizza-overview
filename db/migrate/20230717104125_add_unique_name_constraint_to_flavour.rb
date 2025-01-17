class AddUniqueNameConstraintToFlavour < ActiveRecord::Migration[7.0]
  def change
    add_index :flavours, :name, unique: true
  end
end
