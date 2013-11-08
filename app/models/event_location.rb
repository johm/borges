class EventLocation < ActiveRecord::Base
  attr_accessible :address, :description, :title, :url
  has_many :events
  validates :title,:presence => true

  def to_s
    title
  end

  def name_and_id
    "#{title} (#{id})"
  end

end
