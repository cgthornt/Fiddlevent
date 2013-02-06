class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # For user registration
  attr_accessor :user_type

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_type
  
  has_and_belongs_to_many :roles
  has_one :merchant
  
  before_create :set_user_type_role

  def set_user_type_role
    return if user_type.nil?
    puts "=== ASSIGNING USER TYPE"
    type = user_type == "merchant" ? "merchant" : "customer"
    roles << Role.where(:system_name => type).first
  end
  
  def admin?
    return role? :admin
  end
  
  def merchant?
    return role? :merchant
  end
  
  
  def role?(symbol)
    sym_roles.key? symbol
  end
  
  def sym_roles
    load_roles_and_perms if @sym_roles.nil?
    return @sym_roles
  end
  
protected
  def load_roles_and_perms
    @sym_roles = Hash.new
    roles.find_each do |r|
      #puts r.inspect
      r.self_and_ancestors.each do |role|
        name = role.system_name.to_sym
        @sym_roles.merge!(name => role)
      end
    end
  end
end
