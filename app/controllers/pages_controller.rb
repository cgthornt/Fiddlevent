# This controller represents (mostly) static pages
class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  def register
  end
end
