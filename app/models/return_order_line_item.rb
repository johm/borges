class ReturnOrderLineItem < ActiveRecord::Base
  belongs_to :return_order
  belongs_to :copy
  attr_accessor :quantity
  attr_accessible :copy_id,:return_order_id,:quantity


  def do_return
    copy.do_return()
  end
  

end
