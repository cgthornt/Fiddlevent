# See: https://github.com/ryanb/cancan/wiki/Defining-Abilities
class Ability
  include CanCan::Ability
 
  
  def initialize(user)
    @user = user
    unless user.nil?
      user.sym_roles.each do |role|
        role = "role_#{role.first}"
        send(role) if respond_to?(role)
      end
    end
    anybody
  end
  
  
  def anybody
    can :read, Event
    can :read, Location
    can :read, Merchant
  end
  
  def role_authenticated
    can [:read, :update], User, :id => @user.id
  end
  
  def role_nobody
    can :read, Merchant
    can :read, Event
    can :read, Location
  end
    
  # Abilities for the moderator
  def role_moderator
  end
  
  # Merchant
  def role_merchant
    can :create, Merchant if @user.merchant.nil?
    can [:read, :update], Merchant, :user_id => @user.id
    can :profile, Merchant, :user_id => @user.id
    if(!@user.merchant.nil?)
      can :create, Location
      can :update, Location, :merchant_id => @user.merchant.id
      can :create, Event
      can :update, Event, :merchant_id => @user.merchant.id
      can :manage, FilterSet, :merchant_id => @user.merchant.id 
    end
    #can :manage, Merchant, :user_id => @user.id
  end
  
  # Customer
  def role_customer
  end
  
  # Administrator
  def role_admin
    can :manage, Merchant
    can :manage, User
    can :manage, Filter
    can :manage, FilterSet
    can :manage, Admin
  end
end
