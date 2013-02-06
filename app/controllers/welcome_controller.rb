class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, :show_breadcrumbs
  # The root of the Web site. Currently does nothing
  def index
    @users = User.all
  end
  
  def set_timezone
    if request.post?
      session[:timezone] = params[:nan][:time_zone]
      Time.zone = session[:timezone]
      flash[:success] = "Time zone has been successfully set"
      return redirect_to :back
    end
    render :partial => 'set_timezone'
  end
  
  def features_and_pricing
  end
  
end