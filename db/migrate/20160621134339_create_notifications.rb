class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :sellbook_id
      t.integer :seller_or_buyer
      t.integer :checked

      t.timestamps null: false
    end
  end
end
