class SaleOrder < ActiveRecord::Base
  belongs_to :customer
  belongs_to :user
  has_many :sale_order_line_items
  attr_accessible :customer_po, :discount_percent, :posted,:notes

  default_scope  includes(:sale_order_line_items)

  def cost
    sale_order_line_items.inject(Money.new(0)) {|sum,soli| sum+soli.copy.cost }
  end

  def cost_by_owner(owner)
    sale_order_line_items.inject(Money.new(0)) do |sum,soli| 
      if soli.copy.owner==owner
        sum+soli.copy.cost 
      else
        sum
      end
    end
  end

    

  def subtotal
    sale_order_line_items.inject(Money.new(0)) {|sum,soli| sum+soli.sale_price }
  end

  def subtotal_after_discount 
    Rails.cache.fetch("/sale_order/#{id}-#{updated_at}/subtotal_after_discount", :expires_in => 12.hours) do
      subtotal * ((100-(discount_percent || 0))/100.0)
    end
  end
  
  def tax_amount
    subtotal_after_discount * (ENV["TAX"].to_f || 0.0)
  end

  
  def total
    Rails.cache.fetch("/sale_order/#{id}-#{updated_at}/total", :expires_in => 12.hours) do
      subtotal_after_discount + tax_amount
    end
  end




end
