class Copy < ActiveRecord::Base
  belongs_to :edition
  delegate :title, :to => :edition
  belongs_to :invoice_line_item
  belongs_to :owner
  attr_accessible :cost_in_cents, :is_used, :notes, :price_in_cents , :cost, :price, :inventoried_when, :deinventoried_when, :status, :owner,:edition_id,:invoice_line_item_id
  
  monetize :cost_in_cents, :as => "cost"
  monetize :price_in_cents, :as => "price"

  scope :instock, where("status"=>"STOCK")
  

  def info
    "$#{price}" + (notes || is_used? ? " [#{notes} #{'USED' if is_used?}]" : "" )
  end
  

end
