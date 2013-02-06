# A role is essentially an upside-down tree of roles. The lower in the tree, the more privledged
# the role is, while the higher up the role is, the least privledged the user is. A user lower
# in the tree inherits any parent roles.
#
# Note that this is the inverse permissions
class Role < ActiveRecord::Base
  acts_as_nested_set
  attr_accessible :name, :description, :parent_id
  
  has_and_belongs_to_many :users
  
  def sym_permissions
    load_permissions if @sym_permissions.nil?
    return @sym_permissions
  end
  
  def has_permission?(symbol)
    return sym_permissions.key? symbol
  end
  
protected

  # Gets all possible permissions from the database
  def load_permissions
    @sym_permissions = Hash.new
    permissions.find_each do |p|
      p.self_and_descendants.each do |p2|
        name = p2.system_name.to_sym
        @sym_permissions.merge!(name => p2)
      end
    end
  end
  
end
