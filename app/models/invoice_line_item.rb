class InvoiceLineItem < ActiveRecord::Base
  belongs_to :edition
  belongs_to :invoice
  belongs_to :purchase_order
  attr_accessible :discount, :is_transfer, :quantity
end
