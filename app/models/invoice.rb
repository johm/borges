class Invoice < ActiveRecord::Base
  belongs_to :distributor
  has_many :invoice_line_items
  attr_accessible :notes, :number
end
