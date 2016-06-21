class CreateSellbooks < ActiveRecord::Migration
  def change
    create_table :sellbooks do |t|
      t.string :booktitle
      t.string :book_image
      t.string :book_image2
      t.string :book_image3
      t.string :bookauthor
      t.string :bookpublisher
      t.integer :bookprice
      t.integer :nowbookprice
      t.integer :bookstate
      t.integer :booksellterm
      t.string :sellerip
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
