class CreateSellbooksTags < ActiveRecord::Migration
  def change
    create_table :sellbooks_tags do |t|
      t.belongs_to :tag
      t.belongs_to :sellbook
      t.timestamps null: false
    end
  end
end
