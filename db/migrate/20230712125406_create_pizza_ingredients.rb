class CreatePizzaIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :pizza_ingredients, id: :uuid do |t|
      t.references :pizza, null: false, foreign_key: true, type: :uuid
      t.references :ingredient, null: false, foreign_key: true, type: :uuid
      t.boolean :added, null: false

      t.timestamps
    end
  end
end
