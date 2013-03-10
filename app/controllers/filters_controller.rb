class FiltersController < ApplicationController
  load_and_authorize_resource
  
  
  def index 
  end
  
  def new; end
  def create
    if @filter.save
      flash[:success] = "Filter has been created"
      redirect_to :action => :new
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    if @filter.update_attributes(params[:filter])
      flash[:success] = "Filter has been updated!"
      return redirect_to :action => :index
    end
    
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
