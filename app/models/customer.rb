class Customer < ActiveRecord::Base
  attr_accessible :email, :name, :notes, :phone

  def to_s 
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end


end
