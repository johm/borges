class Distributor < ActiveRecord::Base
  attr_accessible :name, :notes, :our_account_number

#  has_many :copies
#  has_many :editions, :through => :copies
  has_many :invoice_line_items, :through => :invoices
  has_many :copies, :through => :invoice_line_items
  has_many :editions, :through => :copies, :uniq=>true
  has_many :titles, :through => :editions, :uniq=>true
  has_many :purchase_orders
  has_many :invoices
  has_many :return_orders

  def to_s 
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end
  


end
