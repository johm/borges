class Event < ActiveRecord::Base
  belongs_to :event_location

  has_many :event_shifts
  has_many :event_staffers,:through => :event_shifts

  attr_accessible :description, :event_end, :event_start, :published, :title, :event_location_id, :event_location,:picture,:remote_picture_url,:introduction,:internal_notes,:show_on_2640_page,:show_on_red_emmas_page,:event_setup_starts,:event_breakdown_ends,:event_shifts_attributes,:rental_payment_info,:facebook_url

  validates :event_start, :presence => true  
  validates :event_end, :presence => true
  validates :title, :presence => true
  validates :event_location, :presence => true
  
  mount_uploader :picture, ImageUploader  

  accepts_nested_attributes_for :event_shifts, :allow_destroy => true
  
  def self.by_month(month)
    where('extract(month from event_start) = ?', month)
  end

  def self.by_year(year)
    where('extract(year from event_start) = ?', year)
  end

  def start_time
    event_start
  end



end
