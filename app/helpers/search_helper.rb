module SearchHelper
  
  def filter_checked(filter_id)
    return true if params[:fid].blank?
    return params[:fid][filter_id.to_s] == "1"
  end
  
end
