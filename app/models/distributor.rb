class Distributor < ActiveRecord::Base
  attr_accessible :name, :notes, :our_account_number

  def to_s 
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end
  
end
