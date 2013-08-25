class InvoiceLineItem < ActiveRecord::Base
  belongs_to :edition
  belongs_to :invoice
  belongs_to :purchase_order
  attr_accessible :discount, :is_transfer, :quantity,:invoice_id,:edition_id,:price

  monetize :price_in_cents,:as=>:price
  monetize :ext_in_cents,:as=>:ext

  before_validation :recalculate_ext

  def ext_price_string
    ext.to_s
  end

  def as_json(options = {})
    options[:methods] = :ext_price_string
    super(options)
  end

  def potential_po_matches 
    #List of purchase orders that have a line item where the quantity ordered-quantity received is greater than the quantity specified when creating the line item
    edition.purchase_order_line_items.joins(:purchase_order).where(:purchase_orders => {:ordered => true}).find_all {|x| (x.quantity-x.received) >= quantity}
  end


  private
  def recalculate_ext
    self.discount=40 if discount.nil?
    if quantity && price && discount 
      self.ext=price*quantity*((100-discount)/100)
    else
      self.ext=Money.new(0)
    end
  end

end
