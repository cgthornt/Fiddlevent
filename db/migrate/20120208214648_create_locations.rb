class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :address_2
      t.string :city
      t.integer :state_id
      t.integer :zip
      t.integer :merchant_id

      t.timestamps
    end
  end
end
