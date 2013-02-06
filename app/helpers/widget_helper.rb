module WidgetHelper
  def horizontal_form_for(record, options = {}, &proc)
    opts = {:html => {:class => 'form-horizontal'}}
    opts.merge!(options)
    return simple_form_for(record, opts, &proc)
  end
  
  def horizontal_old_form_for(record, options = {}, &proc)
    opts = {:html => {:class => 'form-horizontal'}}
    opts.merge!(options)
    return form_for(record, opts, &proc)
  end
  
  def remote_modal(id, url)
    render :partial => 'shared/remote_modal', :locals => {:url => url, :id => id}
  end
  
  def image_upload_preview(model, attribute)
    render :partial => 'shared/image_upload_preview', :locals => {:model => model, :attribute => attribute}
  end
  
  
  def show_location_map(location, height,  width = '100%', zoom = 17)
    options = {:latitude => location.latitude, :longitude => location.longitude, :zoom => zoom}
    render :partial => 'shared/location_map', :locals => {:location => location, :width => width, :height => height, :map_options => options }
  end
  
end
