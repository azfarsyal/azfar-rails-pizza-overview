class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions, id: :uuid do |t|
      t.string :name, null: false
      t.integer :charge_for_item, null: false
      t.integer :serving_count, null: false
      t.references :flavour, null: false, foreign_key: true, type: :uuid
      t.references :size, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
