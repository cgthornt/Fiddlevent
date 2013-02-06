class AddRoot < ActiveRecord::Migration
  def change
    add_column :events, :filter_set_id, :integer
    add_index :events, :filter_set_id
    
    Filter.create!(:name => 'Root', :description => 'The root.')
  end
end
