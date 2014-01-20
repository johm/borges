class EventStaffer < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :event_shifts
  has_many :events, :through => :event_shifts 

  def name_email 
    "#{name} [#{email}]"
  end

  def to_s
    name_email
  end
  
end
