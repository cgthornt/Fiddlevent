class Filter_Sets_Controller < ApplicationController
  load_and_authorize_resource

def create
    if @filter_set.save
      flash[:success] = "Filter Set has been created"
      redirect_to @filter
    else
      render :action => :new
    end
end
end