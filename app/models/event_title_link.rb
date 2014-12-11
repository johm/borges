class EventTitleLink < ActiveRecord::Base
  belongs_to :event
  belongs_to :title
  attr_accessible :title_id,:event_id,:title
end
