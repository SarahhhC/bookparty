class CreateWarns < ActiveRecord::Migration
  def change
    create_table :warns do |t|
      t.integer :user_id
      t.integer :warner
      t.integer :count
      t.timestamps null: false
    end
  end
end
