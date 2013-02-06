class CreateMerchantTable < ActiveRecord::Migration
  
  def change
    create_table :merchants do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.timestamps
    end
    add_index :merchants, :user_id
  end
  
end
