class CreateFilterSets < ActiveRecord::Migration
  def change
    create_table :filter_sets do |t|
      t.integer :id
      t.integer :merchant_id
      t.string :name
      t.text :description

      t.timestamps
    end
    
    create_table :filters_filter_sets, :id => false do |t|
      t.integer :filter_id
      t.integer :filter_set_id
    end
    
    add_index :filter_sets, :merchant_id
    add_index :filters_filter_sets, [:filter_id, :filter_set_id]
    
  end
end
