class ChangeImagesName < ActiveRecord::Migration
  def up
    drop_attached_file :events, :image
    drop_attached_file :locations, :image
    drop_attached_file :merchants, :image
    change_table :events do |t|
      t.has_attached_file :event_image
    end
    change_table :locations do |t|
      t.has_attached_file :location_image
    end
    change_table :merchants do |t|
      t.has_attached_file :merchant_image
    end
  end

  def down
  end
end
