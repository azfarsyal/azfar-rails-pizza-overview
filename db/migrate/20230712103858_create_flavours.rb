class CreateFlavours < ActiveRecord::Migration[7.0]
  def change
    create_table :flavours, id: :uuid do |t|
      t.string :name, null: false
      t.float :base_price, null: false

      t.timestamps
    end
  end
end
