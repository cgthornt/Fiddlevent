module FiltersHelper
  
  def filter_helper_test(filter)
    html= ""
    filter.each do |f|
      html << f.name
    end
    return html
  end
  
end
