class Filter < ActiveRecord::Base
  has_and_belongs_to_many :filter_sets
  
  validates_presence_of :name, :description, :group_name
  
  def title
    return name
  end
  
  # Gets all in a hash
  # { "Group Name" => [Filter1, Filter2], "Another Group" => [Filter 3, Filter 4], ... }
  def self.get_all_hash
    hash = ActiveSupport::OrderedHash.new
    last_group = nil
    Filter.order('group_name, position').each do |f|
      if last_group != f.group_name
        last_group = f.group_name
        hash[last_group] = Array.new
      end
      hash[last_group] << f
    end
    return hash
  end
end
