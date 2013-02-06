class CreateEventSubscriptions < ActiveRecord::Migration
  def change
    create_table :event_subscriptions do |t|
      t.integer :event_id
      t.integer :user_id
      t.string :email
      t.string :phone_number
      t.string :ip_address

      t.timestamps
    end
  end
end
