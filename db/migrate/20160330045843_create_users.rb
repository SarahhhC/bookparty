class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :userschool
      t.string :usermajor
      t.string :userpw
      t.string :usermail
      t.string :userphone
      t.float :usergrade
      t.timestamps null: false
    end
  end
end
