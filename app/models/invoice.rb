class Invoice < ActiveRecord::Base
  belongs_to :distributor #where the books came from
  belongs_to :owner #who gets the books
  has_many :invoice_line_items
  has_many :editions, :through => :invoice_line_items
  attr_accessible :notes, :number, :distributor_id,:shipping_cost,:owner_id
  monetize :shipping_cost_in_cents, :as => "shipping_cost"
  validates :owner,:presence=>true

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
