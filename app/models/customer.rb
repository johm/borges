class Customer < ActiveRecord::Base
  attr_accessible :email, :name, :notes, :phone
end
