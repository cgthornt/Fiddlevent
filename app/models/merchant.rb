class Merchant < ActiveRecord::Base

  validates_presence_of :name, :description, :user
  has_many :events
  has_many :locations
  belongs_to :user
  has_many :filter_sets
  
  has_attached_file :merchant_image, :styles => Event::IMAGE_STYLES
end
