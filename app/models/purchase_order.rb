class PurchaseOrder < ActiveRecord::Base
  belongs_to :customer
  belongs_to :distributor
  attr_accessible :notes, :number, :ordered, :ordered_when
end
