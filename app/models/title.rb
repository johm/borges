class Title < ActiveRecord::Base
  attr_accessible :title

  has_many :contributions
  has_many :authors, :through => :contributions

end
