class CreateTagsSellbooks < ActiveRecord::Migration
  def change
    create_table :tags_sellbooks do |t|
      t.integer :tag_id
      t.integer :sellbook_id
      
      t.timestamps null: false
    end
  end
end
