class DenormalizeFilters < ActiveRecord::Migration
  def change
    remove_column :filters, :parent_id
    remove_column :filters, :lft
    remove_column :filters, :rgt
    add_column :filters, :group_name, :string
    add_column :filters, :position, :integer
    add_index :filters, :group_name
    add_index :filters, :position
    add_index :filters, [:group_name, :position]
    add_index :filters, [:position, :group_name]
  end
end
