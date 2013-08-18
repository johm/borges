class PurchaseOrderLineItem < ActiveRecord::Base
  belongs_to :edition
  belongs_to :purchase_order
  attr_accessible :quantity, :edition_id, :purchase_order_id


  def isbn 
    if ! edition.nil?
      edition.isbn13 || edition.isbn10 || nil
    end
  end

  def ext_price 
    edition.list_price * quantity
  end

end
