class SaleOrderLineItem < ActiveRecord::Base
  belongs_to :sale_order
  belongs_to :copy

  # attr_accessible :title, :body
end
