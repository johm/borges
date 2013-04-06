class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  
  has_many :contributions
  has_many :titles, :through => :contributions

end
