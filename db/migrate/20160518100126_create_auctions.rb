class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.integer :user_id
      t.integer :sellbook_id
      t.integer :auctionprice
      t.integer :finished
      t.timestamps null: false
    end
  end
end