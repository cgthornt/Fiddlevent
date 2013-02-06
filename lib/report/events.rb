# Reports for events for a specific event
class Report::Events
  include Datagrid
  scope { Event } # Should change on the fly
  
  column :name
end
