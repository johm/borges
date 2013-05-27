class Publisher < ActiveRecord::Base
  attr_accessible :description, :name, :notes
  has_many :titles

  def to_s 
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end


end
