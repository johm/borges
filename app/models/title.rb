class Title < ActiveRecord::Base
  attr_accessible :title,:contributions_attributes,:authors_attributes,:editions_attributes,:publisher_id,:description

  has_many :contributions
  has_many :authors, :through => :contributions
  has_many :editions 
  has_many :copies, :through => :editions
  has_many :purchase_order_line_items, :through => :editions
  belongs_to :publisher
 
  accepts_nested_attributes_for :contributions, :allow_destroy => true
  accepts_nested_attributes_for :editions, :allow_destroy => true
  
  def to_s
    title
  end

  def latest_edition
    editions.newest_first.first
  end

  def latest_edition?
    latest_edition
  end

  
end
