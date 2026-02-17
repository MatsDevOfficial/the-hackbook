class CreatePrizes < ActiveRecord::Migration[8.0]
  def change
    create_table :prizes do |t|
      t.string :name, null: false
      t.text :description
      t.integer :cost, null: false, default: 0
      t.integer :stock_count, default: 0
      t.string :image_url
      t.string :category

      t.timestamps
    end
  end
end
