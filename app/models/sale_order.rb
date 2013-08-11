class SaleOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :sale_order_line_items
  attr_accessible :customer_po, :discount_percent, :from_pos, :from_web, :posted, :tax_amount_in_cents, :total_in_cents
end
