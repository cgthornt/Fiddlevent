# This file contains any additional methods that can be used by the "form_for"
# tag.This Web site has a very good tutorial on how to do so:
# http://code.alexreisner.com/articles/form-builders-in-rails.html
class FormBuilderAdditions < ActionView::Helpers::FormBuilder
  
  def datetime_field(method)
    val = @object.send(method)
    val = DateTime.now if val.blank?
    @template.render :partial => 'shared/datetime_select', :locals => {:attr => method, :obj_name => @object_name, :id => "#{@object_name}_#{method}", :obj => @object, :val => val }
    #return @template.text_field(@object_name, "#{method}_date")# + @template.hidden_field(@object_name, method)
  end
  
  def show_errors
    if @object.errors.any?
      @template.render :partial => 'shared/form_errors', :locals => {:obj => @object}
    end
  end
  
  def auto_label(method, content_or_options = nil, options = nil, &block)
    content_is_options = content_or_options.is_a?(Hash)
    if content_is_options || block_given?
      options = content_or_options if content_is_options
      text = nil
    else
      text = content_or_options
    end
    options ||= {}
    
    klass = @object.class
    lbl = text.nil? ? klass.human_attribute_name(method) : text
    required = klass.validators_on(method).map(&:class).include?(ActiveModel::Validations::PresenceValidator)
    lbl += ' <span class="required">*</span>' if required
    return label(method, lbl.html_safe, options, &block)
  end
  
  def left_label(method, content_or_options = nil, options = nil, &block)
    content_is_options = content_or_options.is_a?(Hash)
    if content_is_options || block_given?
      options = content_or_options if content_is_options
      text = nil
    else
      text = content_or_options
    end
    options ||= {}
    options = {:class => 'control-label'}.merge(options)
    return auto_label(method, content_or_options, options)
  end
  
  
  # Creates a date/time range
  def datetime_range(attribute_start, attribute_stop, &block)
    
    # Start datetime
    start_datetime = @object.send(attribute_start)
    start_date = start_datetime.strftime("%m/%d/%Y") unless start_datetime.blank?
    start_time = start_datetime.strftime("%I:%M%p")  unless start_datetime.blank?
    
    # Stop Datetime
    stop_datetime = @object.send(attribute_stop)
    stop_date = stop_datetime.strftime("%m/%d/%Y") unless stop_datetime.blank?
    stop_time = stop_datetime.strftime("%I:%M%p")  unless stop_datetime.blank?
    
    @template.render :partial => 'shared/datetime_range', :locals => {
      :o_id => "datetime_#{@object_name}",
      :obj_name => @object_name,
      :attr_start => attribute_start,
      :attr_stop => attribute_stop,
      :obj => @object,
      :block => block,
      :has_block => block_given?,
      :stop_date => stop_date,
      :start_date => start_date,
      :stop_time => stop_time,
      :start_time => start_time,
    }
  end
  
end