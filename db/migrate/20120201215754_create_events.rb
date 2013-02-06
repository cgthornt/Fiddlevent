class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :merchant_id
      t.integer :location_id
      t.string :name
      t.text :description
      t.datetime :time_start
      t.datetime :time_stop

      t.timestamps
    end
  end
end
