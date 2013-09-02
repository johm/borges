class Invoice < ActiveRecord::Base
  belongs_to :distributor
  has_many :invoice_line_items
  has_many :editions, :through => :invoice_line_items
  attr_accessible :notes, :number, :distributor_id,:shipping_cost
  monetize :shipping_cost_in_cents, :as => "shipping_cost"

  def receive
    return if received?
    invoice_line_items.each {|ili| ili.receive}
    self.received=true
    self.received_when=DateTime.now
    self.save
  end

  def total_titles
    editions.uniq.length
  end
  
  def total_copies
    invoice_line_items.inject(0){|sum,li| sum+li.quantity }
  end
  
  def total_cost
    invoice_line_items.inject(Money.new(0)){|sum,li| sum+li.ext }
  end

end
