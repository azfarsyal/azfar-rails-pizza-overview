class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.float :total_price
      t.integer :status, default: 0, null: false
      t.timestamp :completed_at
      t.references :discount, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
