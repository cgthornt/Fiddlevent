class FilterSet < ActiveRecord::Base  
  has_and_belongs_to_many :filters
  belongs_to :merchant
  has_many :events
  
  validates_presence_of :name, :filters, :merchant

  def has_filter?(filter)
    filter_ids.include? filter.id
  end
  
  def create_filters!(param_filters)
    return if param_filters.blank?
    filters.clear
    param_filters.each do |filter_id,enabled|
      if enabled == "1" and filter_id != "1"
        filters << Filter.find(filter_id)
      end
    end
  end

  
end
