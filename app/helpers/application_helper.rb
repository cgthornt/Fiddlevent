module ApplicationHelper
  ActionView::Base.default_form_builder = FormBuilderAdditions
  
  include WidgetHelper
  
  
  def select_options_for_states
    State.select('id, name').all.collect{|s| [s.name, s.id]}
  end
  
  def current_timezone
    cookies[:timezone] = "Arizona" unless cookies.key? :timezone
    ActiveSupport::TimeZone[cookies[:timezone]] ||= ActiveSupport::TimeZone["Arizona"]
  end
  
  def main_menu_navigation
    nav1 = ActiveSupport::OrderedHash.new
    nav2 = ActiveSupport::OrderedHash.new
    
    nav1["Home"]   = {:url => {:controller => '/welcome', :action => :index}}
    nav1["Search"] = {:url => {:controller => '/search', :action => :index}}
    
    if current_user and (current_user.role? :merchant || !current_merchant.blank?)
      children = ActiveSupport::OrderedHash.new
      children["My Profile"] = {:url => {:controller => '/merchants', :action => :profile}}
      children["Events"] = {:url => {:controller => '/events', :action => :index}}
      children["Locations"] = {:url => {:controller => '/locations', :action => :index}}
      nav1["Merchant Profile"] = {:url => '#', :url_options => {:id => 'merchant_profile_links'}, :children => children}
    end
    
    
    if current_user and current_user.role? :admin
      admin_sublinks = ActiveSupport::OrderedHash.new
      admin_sublinks["Filters"] = {:url => {:controller => '/filters', :action => :index}}
      nav1["Administration"] = {:url => '#', :url_options => {:id => 'admin_links'}, :children => admin_sublinks}
    end
    

    
    if user_signed_in?
      nav2["Profile"] = {:url => {:controller => :users, :action => :show, :id => (current_user.nil? ? 0 : current_user.id) }}
      nav2["Log Out"] = {:url => destroy_user_session_path, :url_options => {:method => :delete}}
    else
      nav2["Register"] = {:url => {:controller => '/pages', :action => :register}}
      nav2["Log In"]   = {:url => {:controller => '/devise/sessions', :action => :new}}
    end
    
    
    return [main_menu_nav_helper(nav1), main_menu_nav_helper(nav2)]
  end
  
  def main_menu_nav_helper(nav, dropdown_options = {})
    is_dropdown = !dropdown_options.blank?
    html = []
    nav.each do |title,options|
      active = false
      if options[:url].is_a?(Hash)
        active = true if options[:url][:controller] == "/#{params[:controller]}"
      end
      dropdown = options.key?(:children)
      url_options = options[:url_options] || {}
      li_class = ""
      li_class << "active " if active
      li_class << "dropdown " if dropdown
      dropdown_html = ""
      if dropdown
        url_options.merge!({
          'role' => 'button',
          'data-toggle' => 'dropdown',
          'data-target' => '#'
        })
        dropdown_html = content_tag(:ul, :class => 'dropdown-menu', :role => 'menu', 'aria-labelledby' => url_options[:id]) do
          main_menu_nav_helper(options[:children], {}).join("").html_safe
        end
      end
      
      if is_dropdown
        url_options.merge!(dropdown_options)
      end
      
      link_text = title
      link_text = link_text + " " + content_tag(:b, "", :class => "caret") if dropdown
      the_html = content_tag(:li, :class => li_class) do
        link_to(link_text.html_safe, options[:url], url_options) + dropdown_html
      end
      html << the_html
    end
    return html
  end
  
  
  def get_liked_events(max_likes = 20)
    return [] if cookies[:liked].blank?
    count = 0
    ids = []
    lk = cookies[:liked].split(',')
    lk.each do |id|
      break if count > max_likes
      ids << id
      count += 1
    end
    events = Event.where(:id => ids).all
    
    # Cookie found with an ID but doesn't exist
    if events.blank? and !cookies[:liked].blank?
      cookies[:liked] = ""
    end
    
    return events
  end
  
  def event_liked?(event_id)
    return false if cookies[:liked].blank?
    return cookies[:liked].split(",").include?(event_id.to_s)
  end
  
  
  def get_page_title
    title = ""
    if defined? @page_title and !@page_title.blank?
      title = @page_title + " | "
    end
    return title
  end
  
  def page_title(title, subheader = nil)
    @page_title = title
    html = '<div class="page-header"><h1>' + title
    html += " <small>#{subheader}</small" unless subheader.blank?
    html += "</h1></div>"
    content_for :page_title do
      raw(html)
    end
  end
  
  def form_builder(model, &block)
    builder = FormCreator.new(model)
    block.call(builder)
    render :partial => 'shared/form_creator', :locals => {:builder => builder}
  end
  
  def filter_set_tree_for(filter_set)
    render :partial => 'shared/filter_set_tree', :locals => {:filter_set => filter_set}
  end
  
  
  def format_long_text(text)
    simple_format h(text)
  end
  
  def summarize(text, length = 255)
    truncate(strip_tags(text), :length => length)
  end
  
end
