class MerchantsController < ApplicationController
  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => [:show, :index]
  before_filter :add_breadcrumb_for_curr_merchant, :except => [:index, :profile]
  
  def index; end
  def new; end
  
  def show
    @upcoming = EventSearch.new.merchant(@merchant).in_future.get
  end
  
  def create
    @merchant.user = current_user
    if @merchant.save
      flash[:success] = "Merchant profile has been created"
      redirect_to :controller => :merchant, :action => :profile
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    if @merchant.update_attributes(params[:merchant])
      flash[:success] = "Your profile has been updated."
      redirect_to @merchant
    else
      render :action => :edit
    end
  end
  
  def profile
    if @merchant.nil? && current_user.merchant.nil?
      flash[:info] = "You must first create a merchant profile"
      return redirect_to new_merchant_path
    end
    if @merchant.nil?
      @merchant = Merchant.includes(:events, :locations).where(:user_id => current_user.id).first
    end
  end
  
end
