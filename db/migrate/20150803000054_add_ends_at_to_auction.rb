class AddEndsAtToAuction < ActiveRecord::Migration
  def change
    add_column :product_auctions, :ends_at, :timestamp
  end
end
