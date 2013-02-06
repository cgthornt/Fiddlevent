class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
