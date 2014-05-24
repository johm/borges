class AddStuffToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_cart,:shipping_method,:string
    add_column :shopping_cart,:shipping_email,:string
    add_column :shopping_cart,:shipping_subscribe,:boolean
    add_column :shopping_cart,:shipping_stripe_id,:string
  end
end
