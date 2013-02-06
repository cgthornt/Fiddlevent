class CreateRoles < ActiveRecord::Migration
  def change
   create_table :roles do |t|
    t.string :name
    t.string :description
    t.string :system_name
    t.boolean :assignable, :default => true
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
   end
   
   create_table :permissions do |t|
    t.string :name
    t.string :description
    t.string :system_name
    t.boolean :assignable, :default => true
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
   end
   
   create_table :roles_users, :id => false do |t|
     t.integer :role_id
     t.integer :user_id
   end
   
   create_table :permissions_roles, :id => false do |t|
     t.integer :role_id
     t.integer :permission_id
   end
   
   add_index :roles, :system_name, :unique => true
   add_index :permissions, :system_name, :unique => true
   add_index :roles_users, [:role_id, :user_id]
   add_index :permissions_roles, [:role_id, :permission_id]
   
  end
end
