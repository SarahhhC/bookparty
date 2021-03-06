class CreateSellbooks < ActiveRecord::Migration
  def change
    create_table :sellbooks do |t|
      t.string :booktitle
      t.string :book_image
      t.string :bookauthor
      t.string :bookpublisher
      t.integer :bookinitprice
      t.integer :bookprice
      t.integer :nowbookprice
      t.integer :bookstate
      t.integer :booksellterm
      t.string :sellerip
      t.integer :bookgrade
      t.integer :bookview
      t.integer :bookauction
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
