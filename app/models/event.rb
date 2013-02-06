class Event < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :location
  belongs_to :filter_set
  has_many :filters, :through => :filter_set
  validates_presence_of :name, :location, :description, :time_start, :time_stop, :filter_set
  validate :ensure_datetime_range
  
  validates_length_of :name, :maximum => 50
  
  attr_accessor :facebook_url
  
  IMAGE_STYLES = { :medium => '300x300#', :small => '170x170#', :thumbnail => '80x80#', :tiny => '50x50#' }
  
  scope :upcoming, where("`events`.`time_stop` >= NOW()")
  
  def ensure_datetime_range
    unless time_start.blank? or time_stop.blank?
      errors.add(:time_start, "cannot be after the event starting time") if time_start > time_stop
    end
  end
  
  has_attached_file :event_image, :styles => IMAGE_STYLES
  
  def facebook_url
    fb_event_id.blank? ? "" : "https://www.facebook.com/events/#{fb_event_id}"
  end
  
  def facebook?; !fb_event_id.blank?; end
  
  def time_to_s
    str = time_start.strftime("%A %B %e, %l:%M %p") + " to "
    if time_start.to_date === time_stop.to_date
      str += time_stop.strftime("%l:%M %p")
    else
      str += time_stop.strftime("%B %e, %l:%M %p")
    end
    return str
  end
  
end
