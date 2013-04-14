class Title < ActiveRecord::Base
  attr_accessible :title,:contributions_attributes,:authors_attributes,:editions_attributes

  has_many :contributions
  has_many :authors, :through => :contributions
  has_many :editions


  accepts_nested_attributes_for :contributions, :allow_destroy => true
  accepts_nested_attributes_for :editions, :allow_destroy => true
  
  

end
