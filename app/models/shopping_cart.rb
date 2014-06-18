class ShoppingCart < ActiveRecord::Base
  attr_accessible :session_id, :shipping_address_1, :shipping_address_2, :shipping_city, :shipping_name, :shipping_state, :shipping_zip,:shipping_method,:shipping_email,:shipping_subscribe
  has_many :shopping_cart_line_items
  
  SHIPPING_OPTIONS=[["Pick up at the store","pickup"],["Have it delivered by bicycle (within TK miles of the store)","bike"],["Ship it via USPS Priority mail","usps"]]
  validates_inclusion_of :shipping_method, :in => SHIPPING_OPTIONS

  
  def active?
    shopping_cart_line_items != []
  end
  
  def number_of_items
    shopping_cart_line_items.length
  end

  def total
    shopping_cart_line_items.inject(Money.new(0)) { |sum,i| sum + (i.cost * i.quantity)}
  end

  def ordered?
    submitted?
  end

end
