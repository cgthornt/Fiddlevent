class RenameFilterFilterSets < ActiveRecord::Migration
  def up
    rename_table :filters_filter_sets, :filter_sets_filters
  end

  def down
    rename_table :filter_sets_filters, :filters_filter_sets
  end
end
