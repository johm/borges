class PurchaseOrderLineItem < ActiveRecord::Base
  belongs_to :edition
  has_one :title, :through => :edition
  belongs_to :purchase_order, :touch => true
  belongs_to :customer
  attr_accessible :quantity, :edition_id, :purchase_order_id, :customer_id,:customer,:notes,:received
  has_many :invoice_line_items
  validates :edition,:presence=>true
  validates :purchase_order,:presence=>true

  default_scope includes(:title).order('titles.title asc')

  def isbn 
    if ! edition.nil?
      edition.isbn13 || edition.isbn10 || nil
    end
  end

  def still_outstanding 
    quantity-received 
  end

  def cancel 
    outstanding=self.quantity-self.received 
    self.cancelled=outstanding
    newquantity=self.quantity-outstanding
    self.quantity=newquantity
    self.save!
  end

  def ext_price 
    begin
      edition.list_price * quantity
    rescue
      Money.new(0)
    end
  end

  def ext_price_string
    ext_price.to_s
  end

  def as_json(options = {})
    options[:methods] = :ext_price_string
    super(options)
  end


end
