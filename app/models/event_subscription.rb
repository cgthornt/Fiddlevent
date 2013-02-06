class EventSubscription < ActiveRecord::Base
  attr_accessible :email, :event_id, :ip_address, :phone_number, :user_id
end
