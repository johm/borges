class Invoice < ActiveRecord::Base
  belongs_to :distributor #where the books came from
  belongs_to :owner #who gets the books
  has_many :invoice_line_items
  has_many :editions, :through => :invoice_line_items
  has_many :copies, :through => :invoice_line_items
  attr_accessible :notes, :number, :distributor_id,:shipping_cost,:owner_id,:received_by
  monetize :shipping_cost_in_cents, :as => "shipping_cost"
  validates :owner,:presence=>true
  validates :distributor,:presence=>true
  
  default_scope includes(:invoice_line_items => [:edition]) 

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
    invoice_line_items.inject(0){|sum,li| sum+li.quantity rescue sum } 
  end
  
  def total_cost
    invoice_line_items.inject(Money.new(0)){|sum,li| sum+li.ext }
  end

  def sales_to_date
    return Money.new(0) unless received?
    all_copies_from_this_invoice=invoice_line_items.collect {|li| li.copies}.flatten
    all_copies_from_this_invoice.select {|c| c.status=="SOLD"}.inject(Money.new(0)){|sum,li| sum+li.price}
  end

  def returns_to_date
    return Money.new(0) unless received?
    all_copies_from_this_invoice=invoice_line_items.collect {|li| li.copies}.flatten
    all_copies_from_this_invoice.select {|c| c.status=="RETURNED"}.inject(Money.new(0)){|sum,c| sum+c.cost}
  end

  def lost_to_date
    return Money.new(0) unless received?
    all_copies_from_this_invoice=invoice_line_items.collect {|li| li.copies}.flatten
    all_copies_from_this_invoice.select {|c| c.status=="LOST"}.inject(Money.new(0)){|sum,li| sum+li.price}
  end


end
