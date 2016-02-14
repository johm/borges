class PurchaseOrder < ActiveRecord::Base
  # there should be a mechanism by which purchase order line items can be checked off against invoices
  validates :number, :uniqueness => true
  validates :number, :presence => true

  belongs_to :distributor #where the books came from
  belongs_to :owner #who gets the books

  has_many :purchase_order_line_items,dependent: :destroy
  attr_accessible :notes, :number, :ordered, :ordered_when,:order_by_when, :distributor_id,:owner_id,:tag

  default_scope  includes(:purchase_order_line_items)
  
  def self.tags
    ['Normal','Frontlist','Course books','Event order','Tabling order','Special order','Used books','Remainders']
  end
    

  def estimated_total
    purchase_order_line_items.inject(Money.new(0)) {|sum,li| sum+li.ext_price   }
  end
 
  def estimated_total_string
    purchase_order_line_items.inject(Money.new(0)) {|sum,li| sum+li.ext_price   }.to_s
  end

 def number_of_copies
    purchase_order_line_items.inject(0) {|sum,li| sum+li.quantity}
 end

 
 def outstanding 
   purchase_order_line_items.inject(0) {|sum,li| sum+li.quantity-li.received}
 end

 def cancel 
   purchase_order_line_items.each {|poli| poli.cancel}
 end


  def as_json(options = {})
    options[:methods] = :estimated_total_string
    super(options)
  end

end
