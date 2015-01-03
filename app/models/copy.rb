class Copy < ActiveRecord::Base
  belongs_to :edition, :touch => true
  delegate :title, :to => :edition
  belongs_to :invoice_line_item
  has_one :invoice,:through => :invoice_line_item 
  has_one :sale_order_line_item
  has_one :sale_order,:through => :sale_order_line_item 
  has_one :return_order_line_item
  has_one :return_order,:through => :return_order_line_item 
  belongs_to :owner
  attr_accessible :cost_in_cents, :is_used, :notes, :price_in_cents , :cost, :price, :inventoried_when, :deinventoried_when, :status, :owner,:edition_id,:invoice_line_item_id, :owner_id
  has_many :inventory_copy_confirmations  
  monetize :cost_in_cents, :as => "cost"
  monetize :price_in_cents, :as => "price"

  scope :instock, where("status"=>"STOCK")
  scope :lost, where("status"=>"LOST")
  scope :returned, where("status"=>"RETURNED")
  scope :sold, where("status"=>"SOLD")
  

  def info
    "$#{price}" + (notes || is_used? ? " [#{notes} #{'USED' if is_used?}]" : "" )
  end

  def sell(sale_price)
    self.price=sale_price # this comes from the line item
    self.status="SOLD"
    self.deinventoried_when=DateTime.now
    self.save!
  end
  
  def do_return()
    self.status="RETURNED"
    self.deinventoried_when=DateTime.now
    self.save!
  end


  def mark_lost()
    if self.status=="STOCK"
      self.status="LOST"
      self.deinventoried_when=DateTime.now
      self.save!
    end
  end

  def confirm(inventory)
    @inventory_copy_confirmation = InventoryCopyConfirmation.new(:copy=>self,:inventory=>inventory)
    @inventory_copy_confirmation.status=true
    @inventory_copy_confirmation.save!
  end


end
