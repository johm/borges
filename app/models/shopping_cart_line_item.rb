class ShoppingCartLineItem < ActiveRecord::Base
  belongs_to :shopping_cart
  belongs_to :edition
  attr_accessible :cost_in_cents, :quantity
  monetize :cost_in_cents, :as => :cost
end
