class AddFbIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fb_event_id, :string
  end
end
