class EventSearch
  
  def initialize
    @search = Event.includes(:merchant, :location, :filter_set => :filters)
  end
  
  def select(vals_to_select)
    @search = @search.select(vals_to_select)
    return self
  end
  
  
  def radius(latitude, longitude, radius_in_miles = 25)
    where_str = "3963.191 * ACOS((SIN(PI() * :lat / 180) * SIN(PI() * locations.latitude / 180)) + (COS(PI() * :lat /180) * cos(PI() * locations.latitude / 180) * COS(PI() * " +
                "locations.longitude / 180 - PI() * :long / 180)) ) <= :radius"
    @search = @search.where(where_str, :lat => latitude, :long => longitude, :radius => radius_in_miles)
    return self
  end
  
  def paginate(current_page, per_page = 20)
    @search = @search.page(current_page).per(per_page)
    return self
  end
  
  
  def in_future
    return time_greater_than(DateTime.now)
  end
  
  def in_past
    return time_less_than(DateTime.now)
  end
  
  def time_greater_than(date_time)
    @search = @search.where("time_stop >= ?", date_time)
    return self
  end
  
  def time_less_than(date_time)
    @search = @search.where("time_stop < ?", date_time)
    return self
  end
  
  def time_between(time_start, time_stop)
    @search = @search.where("time_start >= ? AND time_stop <= ?", time_start, time_stop)
    return self
  end

  def coordinates(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    return self
  end
  
  def merchant(merchant)
    raise ArgumentError.new "Passed merchant must be a merchant object!" unless merchant.is_a? Merchant
    @search = @search.where(:merchants => {:id => merchant})
    return self
  end
  
  def location(location)
    @search = @search.where(:location_id => location.id)
    return self
  end
  
  
  def strong_filter_ids(filter_ids)
    all_ids = []
    filter_ids.map!{|x| x.to_i }
    fs = Filter.select("id").all
    fs.map{|x| all_ids << x.id }
    to_search = all_ids & filter_ids
    
    # Should be safe since we coerce everything into an int
    #@search = @search.where("`filters`.`id` IN(#{to_search.join(', ')})")
    return self
  end
  
  def filter_ids(filter_ids)
    return self if filter_ids.blank?
    
    # We get all possible ID's and subtract the ones that the user selected.
    # We then use that in a "NOT IN" operation to make sure we specifically don't
    # return any results that the user didn't select
    all_ids = []
    filter_ids.map!{|x| x.to_i }
    fs = Filter.select("id").all
    fs.map{|x| all_ids << x.id }
    ids_in = all_ids & filter_ids
    #select("locations.latitude, locations.longitude, (COUNT(filter_sets_filters.filter_set_id) - (SELECT COUNT(*) FROM filter_sets_filters AS fs WHERE fs.filter_set_id = filter_sets.id AND fs.filter_id IN(#{ids_in.join(',')}))) AS weight_diff, events.*")
    @search = @search.where("`filters`.`id` IN(#{ids_in.join(',')})")
    #@search = @search.order('weight_diff ASC')
    
    # Should be safe since we coerce everything into an int
    # @search = @search.where("")
    return self
  end
  
  def limit(limit)
    @searc = @search.limit(limit)
    return self
  end
  
  def get
    @search = @search.group('`events`.`id`').order('time_start ASC')
    return @search
  end
  
  
end
