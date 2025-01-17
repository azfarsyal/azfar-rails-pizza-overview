class AddUniqueNameConstraintToSize < ActiveRecord::Migration[7.0]
  def change
    add_index :sizes, :name, unique: true
  end
end
