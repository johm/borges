class SaleOrderLineItem < ActiveRecord::Base
  belongs_to :sale_order
  belongs_to :copy

  attr_accessible :copy_id,:sale_order_id,:sale_price
  monetize :sale_price_in_cents,:as=>:sale_price



end
