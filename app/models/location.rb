class Location < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :state
  has_many :events
  validates_presence_of :name, :address, :city, :state, :zip
  validates_numericality_of :zip
  validates_length_of :zip, :maximum => 5
  
  def single_line
    self.address + (address_2.blank? ? "" : " #{address_2}") + ", #{city} #{state.code} #{zip}"
  end
  

  has_attached_file :location_image, :styles => Event::IMAGE_STYLES
  
  def to_s
    str = name + ", " + address
    str += ", #{address_2}" unless address_2.blank?
    return str + ", #{city} #{state.code} #{zip}"
  end
  
  def label_for_select
    return "#{address} (#{name})"
  end
end