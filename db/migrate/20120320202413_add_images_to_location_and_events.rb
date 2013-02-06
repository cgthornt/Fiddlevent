class AddImagesToLocationAndEvents < ActiveRecord::Migration
  def up
    change_table :merchants do |t|
      t.has_attached_file :image
    end
    
    change_table :locations do |t|
      t.has_attached_file :image
    end
    
    change_table :events do |t|
      t.has_attached_file :image
    end
  end
  
  def down
    drop_attached_file :merchants, :image
    drop_attached_file :locations, :image
    drop_attached_file :events, :image
  end
end
