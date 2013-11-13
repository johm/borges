class SaleOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :sale_order_line_items
  attr_accessible :customer_po, :discount_percent, :posted,:notes

  default_scope  includes(:sale_order_line_items)

  def subtotal
    sale_order_line_items.inject(Money.new(0)) {|sum,soli| sum+soli.sale_price }
  end

  def subtotal_after_discount 
    subtotal * ((100-(discount_percent || 0))/100.0)
  end
  
  def tax_amount
    subtotal_after_discount * (ENV["TAX"].to_f || 0.0)
  end

  def total
    subtotal_after_discount + tax_amount
  end

end
