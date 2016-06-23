class CreateGmails < ActiveRecord::Migration
  def change
    create_table :gmails do |t|

      t.timestamps null: false
    end
  end
end
