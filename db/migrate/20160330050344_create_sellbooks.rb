class CreateSellbooks < ActiveRecord::Migration
  def change
    create_table :sellbooks do |t|
      t.string :booktitle
      t.string :bookauthor
      t.string :bookpublisher
      t.integer :bookprice
      t.integer :bookstate
      t.integer :booksellterm
      t.integer :user_id
      
      t.timestamps null: false
    end
  end
end
