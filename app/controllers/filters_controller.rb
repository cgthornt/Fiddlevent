class FiltersController < ApplicationController
  load_and_authorize_resource
  
  
  def index 
  end
  
  def new; end
  def create
    if @filter.save
      flash[:success] = "Filter has been created"
      redirect_to filters_path
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def destroy
    if @filter.destroy
      flash[:success] = "Filter has been deleted"
    else
      flash[:error] = "Unable to delete filter"
    end
    redirect_to :action => :index
  end
  
  
end
