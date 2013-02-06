class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :set_user_timezone, :show_breadcrumbs
  protect_from_forgery
  layout "application"  
  
  add_breadcrumb "Home", :root_path
  
  
  rescue_from CanCan::AccessDenied do |exception|
    @exception = exception
    render "pages/errors/access_denied", :status => :unauthorized
  end
  
protected
  def set_user_timezone
    tz = session[:timezone]
    tz = "Arizona" if tz.blank?
    Time.zone = tz
  end
  
  def current_merchant
    # If the current user is a merchant, then return that merchant account
    return current_user.merchant if current_user.merchant?
    
    # Otherwise, look up the merchant, and return it if the user has
    # permission to edit it
    unless session[:merchant_id].blank?
      begin
        m =  Merchant.find(session[:merchant_id])
        return m if current_user.can? :edit, m
      rescue Exception => e; end
    end
    return nil
  end
  
  def set_current_merchant(merchant)
    session[:merchant_id] = merchant.id
  end
  
  def add_breadcrumb_for_curr_merchant
    unless current_merchant.blank?
      add_breadcrumb current_merchant.name, {:controller => '/merchants', :action => 'profile', :id => current_merchant.id }
    end
  end
  
  # Flag to turn on breadcrumbs
  def show_breadcrumbs
    @show_breadcrumbs = true
  end

end
