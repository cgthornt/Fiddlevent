class FilterSetsController < ApplicationController
  load_and_authorize_resource
  add_breadcrumb "Profile", :users_path

  def create
    @filter_set.create_filters!(params[:fid])
    if @filter_set.save
      flash[:success] = "Filter Set has been created"
      redirect_to :action => :edit, :id => @filter_set.id
    else
      render :action => :new
    end
  end
  
  def edit
    params[:fid] = {}
    @filter_set.filters.each do |fs|
      params[:fid][fs.id.to_s] = "1"
    end
  end
  
  def update
    @filter_set.create_filters!(params[:fid])
    if @filter_set.update_attributes(params[:filter_set])
      flash[:success] = "Filter set has been saved"
    end
    render :action => 'edit'
  end
  
  def new
    
    params[:fid] = {:null => 'blank'}
  end
  
  def show
  end
  
  def destroy
    if @filter_set.destroy
      flash[:success] = "Successfully deleted filter set"
      redirect_to current_user
    else
      flash[:error] = "Unable to delete filter set"
      redirect_to @filter_set
    end
  end
end