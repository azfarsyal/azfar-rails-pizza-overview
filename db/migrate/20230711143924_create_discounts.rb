class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts, id: :uuid do |t|
      t.string :name, null: false
      t.integer :percentage, null: false

      t.timestamps
    end
  end
end
