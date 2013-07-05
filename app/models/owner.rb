class Owner < ActiveRecord::Base

  attr_accessible :name, :notes
  has_many :copies

end
