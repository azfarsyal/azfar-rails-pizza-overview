class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients, id: :uuid do |t|
      t.string :name, null: false
      t.float :multiplier, null: false

      t.timestamps
    end
  end
end
