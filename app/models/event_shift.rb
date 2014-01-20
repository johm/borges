class EventShift < ActiveRecord::Base
  belongs_to :event_staffer
  belongs_to :event
  attr_accessible :notes, :event_staffer_id,:event_staffer
end
