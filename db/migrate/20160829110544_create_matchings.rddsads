class CreateMatchings < ActiveRecord::Migration
  def change
    create_table :matchings do |t|
      t.integer :user_id
      t.integer :sellbook_id
      t.integer :auctionprice
      t.timestamps null: false
    end
  end
end
