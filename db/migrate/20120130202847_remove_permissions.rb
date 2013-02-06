class RemovePermissions < ActiveRecord::Migration
  def up
    drop_table :permissions
    drop_table :permissions_roles
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
