class CreateForiegnKeys < ActiveRecord::Migration
  
  def fks
    return [
      # Events
      [:events, :merchants],
      [:events, :locations],
      [:events, :filter_sets],
      
      # Filter Sets
      [:filter_sets, :merchants],
      [:filter_sets_filters, :filters],
      [:filter_sets_filters, :filter_sets],
      
      # Locations
      [:locations, :merchants],
      [:locations, :states],
      
      # Roles
      [:roles_users, :roles],
      [:roles_users, :users],
      
      # Merchants
      [:merchants, :users]
      
    ]
  end
  
  def up
    fks.each do |pair|
      add_foreign_key(pair.first, pair.second, ((pair.second == pair.last) ? {:dependent =>:nullify} : pair.last))
    end
    add_index(:locations, [:latitude, :longitude])
    add_index(:events, :time_start)
    add_index(:events, :time_stop)
  end

  def down
   fks.each do |pair|
      remove_foreign_key(pair.first, pair.second)
    end
  end
end
