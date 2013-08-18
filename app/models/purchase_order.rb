class PurchaseOrder < ActiveRecord::Base
  # there should be a mechanism by which purchase order line items can be checked off against invoices
  validates :number, :uniqueness => true
  validates :number, :presence => true
  

  belongs_to :customer
  belongs_to :distributor
  has_many :purchase_order_line_items
  attr_accessible :notes, :number, :ordered, :ordered_when, :distributor_id
end
