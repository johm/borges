class Event < ActiveRecord::Base
  belongs_to :event_location
  attr_accessible :description, :event_end, :event_start, :published, :title, :event_location_id, :event_location,:picture,:remote_picture_url,:introduction

  validates :event_start, :presence => true  
  validates :event_end, :presence => true
  validates :title, :presence => true
  validates :event_location, :presence => true
  
  mount_uploader :picture, ImageUploader  

  
  def self.by_month(month)
    where('extract(month from event_start) = ?', month)
  end

  def self.by_year(year)
    where('extract(year from event_start) = ?', year)
  end




end
