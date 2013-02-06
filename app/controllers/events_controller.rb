class EventsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :show
  before_filter :add_breadcrumb_for_curr_merchant
  before_filter :add_events_breadcrumb, :except => [:index]
  
  load_and_authorize_resource
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @location = @event.location

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
      format.ajax { render :layout => false }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event.merchant = current_user.merchant
    if @event.merchant.locations.blank?
      flash[:notice] = "You must create at least one location before you continue"
      return redirect_to new_location_path
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
    add_breadcrumb "Profile", :users_path
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    
    @event.merchant = current_user.merchant
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, :notice => 'Event was successfully created.' }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
  
  def add_events_breadcrumb
    add_breadcrumb "Events", events_path
  end
  
end
