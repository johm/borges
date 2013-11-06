class InvoiceLineItem < ActiveRecord::Base
  belongs_to :edition
  belongs_to :invoice
  belongs_to :purchase_order_line_item
  has_many :copies
  attr_accessible :discount, :is_transfer, :quantity,:invoice_id,:edition_id,:price,:purchase_order_line_item_id
  
  validates :edition,:presence=>true


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
    #List of purchase order line items where the quantity ordered-quantity received is greater than the quantity specified when creating the line item
    begin
      edition.purchase_order_line_items.joins(:purchase_order).where(:purchase_orders => {:ordered => true}).find_all {|x| (x.quantity-x.received) >= quantity}
    rescue
      []
    end
  end

  def receive
    # create copies in stock
    (1..quantity).each do |x|
      c=Copy.new(:edition_id => edition.id,
                 :cost => ext/quantity,
                 :price => price,
                 :inventoried_when=>DateTime.now,
                 :invoice_line_item_id=>id,
                 :status=>"STOCK",
                 :owner=>invoice.owner
                 )
      #need to add used, notes in here
      c.save!
    end
    # mark po line item as received
    unless purchase_order_line_item.nil?
      purchase_order_line_item.received = purchase_order_line_item.received + quantity
      purchase_order_line_item.save!
    end
    edition.title.save! #trigger a reindex
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
