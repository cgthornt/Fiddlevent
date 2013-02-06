class LocationsController < ApplicationController
  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => :show
  add_breadcrumb "Profile", :users_path
  
  
  def new
    @location.merchant= current_user.merchant
  end
  
  def create
    @location.merchant= current_user.merchant
    if @location.save
      flash[:success] = "Location has been created"
      redirect_to :action => :show, :id => @location.id
    else
      render :action => :new
    end
  end
  
  def show
    @search= EventSearch.new
    @search.location(@location)
  end
  
  def update
    add_breadcrumb "Profile", :users_path
    if @location.update_attributes(params[:location])
      flash[:success] = "Your location has been updated."
      redirect_to edit_location_path(@location)
    else
      render :action => :edit
    end
  end
  
  def edit
  end
  
end