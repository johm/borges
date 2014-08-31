class SaleOrderLineItem < ActiveRecord::Base
  belongs_to :sale_order,:touch => true
  belongs_to :copy

  attr_accessible :copy_id,:sale_order_id,:sale_price
  monetize :sale_price_in_cents,:as=>:sale_price

  def sell
    copy.sell(sale_price)
  end

  



end
