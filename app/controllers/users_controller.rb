class UsersController < ApplicationController
  load_and_authorize_resource
  
  
  
  def index
    redirect_to current_user
  end
  
  def show
    if @user.merchant?
      
      if @user.merchant.blank?
        flash[:info] = "You need to first create a merchant profile"
        return redirect_to new_merchant_path
      end
      @merchant = @user.merchant
      @upcoming_events = @merchant.events.where('time_stop > ?', Time.now)
      @locations = @merchant.locations.order('locations.name')
    end
  end
  
end
