class CreatePizzas < ActiveRecord::Migration[7.0]
  def change
    create_table :pizzas, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.references :flavour, null: false, foreign_key: true, type: :uuid
      t.references :size, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
