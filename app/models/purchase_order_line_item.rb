class PurchaseOrderLineItem < ActiveRecord::Base
  belongs_to :edition
  belongs_to :purchase_order
  attr_accessible :quantity
end
