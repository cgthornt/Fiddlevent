class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :show_breadcrumbs
  
  def index
    query = params[:query]
    @results = lookup(query)
    @primary = @results.first
    
    unless @primary.blank?
      @events = EventSearch.new.radius(@primary[:latitude], @primary[:longitude], 25)
      
      unless params[:fid].blank?
        ids_to_search = []
        params[:fid].map{|key,value| ids_to_search << key if value == "1" }
        @events.filter_ids(ids_to_search)
      end
      
      @date_start = ""
      # Max Start Date
      unless params[:f].blank? or params[:f][:time_start].blank?
        begin
          @date_start = Date.parse(params[:f][:time_start])
          @events.time_greater_than(@date_start)
          @date_start = @date_start.strftime("%m/%d/%Y")
        rescue; end
      end
      
      @events.in_future if @date_start.blank?
      
      @events = @events.paginate(params[:page], 20).get
      @all_events = @events.all
    end
  end
  
  def cart_ajax
    event = Event.find(params[:event_id])
    render :partial => 'shared/cart_item', :layout => false, :object => event
  end
  
  def event_ajax_full
    @event = Event.includes(:merchant, :location).find(params[:event_id])
    render :layout => false
  end
  
protected

  def lookup(query)
    query = "" if query.blank?
    query = query.downcase.strip
    key = "q_#{query}"
    if Rails.cache.exist?(key)
      puts "CACHE HIT FOR #{query}"
      return Rails.cache.fetch(key)
    else
      # Query the Yahoo API to parse city data
      results = []
      url = URI("http://where.yahooapis.com/geocode?appid=dj0yJmk9aGtVOW1kNVpKUXgxJmQ9WVdrOU1sUllVMHhCTldVbWNHbzlNVFl6TVRBd016UTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD0xOz&q=" + URI.escape(query))
      xml = Nokogiri::XML(Net::HTTP.get(url))
      num_found = xml.xpath("/ResultSet/Found/text()").to_s.to_i
      if num_found != 0
        xml.xpath('/ResultSet/Result').each do |result|
          
          # Use only US results (for now)
          next if result.xpath('countrycode/text()').to_s != "US"
          
          tmp = {
            :latitude     => result.xpath('latitude/text()').to_s.to_f,
            :longitude    => result.xpath('longitude/text()').to_s.to_f,
            :city         => result.xpath('city/text()').to_s,
            :state        => result.xpath('state/text()').to_s,
            :state_code   => result.xpath('statecode/text()').to_s
          }
          tmp[:full_name]  = format_result_name(tmp)
          tmp[:short_name] = format_result_short_name(tmp)
          results << tmp
        end
      end
      Rails.cache.write(key, results, :expires_in => 1.hour)
      return results
    end
  end
  
  def format_result_name(result)
    return "No Results" if result.blank?
    unless result[:city].blank?
      return "#{result[:city]}, #{result[:state]}"
    else
      return "#{result[:state]}"
    end
  end
  
  def format_result_short_name(result)
    return "NA" if result.blank?
    unless result[:city].blank?
      return "#{result[:city]}, #{result[:state_code]}"
    else
      return "#{result[:state_code]}"
    end
  end
  
  
  def apply_radius_criteria(search, lat, lon, radius = 25)
    # From http://mobiforge.com/forum/developing/location/retrieve-latlong-google-geolocation-and-calculate-radius
    
    where_str = "3963.191 * ACOS((SIN(PI() * :lat / 180) * SIN(PI() * locations.latitude / 180)) + (COS(PI() * :lat /180) * cos(PI() * locations.latitude / 180) * COS(PI() * " +
                "locations.longitude / 180 - PI() * :long / 180)) ) <= :radius"
    return search.where(where_str, :lat => lat, :long => lon, :radius => radius)
  end
  

  
  
end
