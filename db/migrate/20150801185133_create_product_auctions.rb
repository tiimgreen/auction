class CreateProductAuctions < ActiveRecord::Migration
  def change
    create_table :product_auctions do |t|
      t.float :value
      t.references :product, index: true

      t.timestamps null: false
    end
    add_foreign_key :product_auctions, :products
  end
end
