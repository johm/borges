class Copy < ActiveRecord::Base
  belongs_to :edition, :touch => true
  delegate :title, :to => :edition
  belongs_to :invoice_line_item
  has_one :sale_order_line_item
  has_one :return_order_line_item
  belongs_to :owner
  attr_accessible :cost_in_cents, :is_used, :notes, :price_in_cents , :cost, :price, :inventoried_when, :deinventoried_when, :status, :owner,:edition_id,:invoice_line_item_id
  
  monetize :cost_in_cents, :as => "cost"
  monetize :price_in_cents, :as => "price"

  scope :instock, where("status"=>"STOCK")
  

  def info
    "$#{price}" + (notes || is_used? ? " [#{notes} #{'USED' if is_used?}]" : "" )
  end

  def sell(sale_price)
    self.price=sale_price # this comes from the line item
    self.status="SOLD"
    self.deinventoried_when=DateTime.now
    self.save!
  end
  
  def do_return()
    self.status="RETURNED"
    self.deinventoried_when=DateTime.now
    self.save!
  end



end
