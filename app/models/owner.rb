class Owner < ActiveRecord::Base

  attr_accessible :name, :notes
  has_many :copies

  def name_and_id
    "#{name} (#{id})"
  end

end
