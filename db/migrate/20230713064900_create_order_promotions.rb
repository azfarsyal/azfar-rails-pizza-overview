class CreateOrderPromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :order_promotions, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.references :promotion, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
