class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  has_many :contributions
  has_many :titles, :through => :contributions

  before_save :set_full_name

  def to_s 
    full_name
  end
  
  def set_full_name
    self.full_name = "#{first_name} #{last_name}"
  end

  def name_and_id
    "#{full_name} (#{id})"
  end


end
