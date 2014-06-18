class AddStuffToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:shipping_method,:string
    add_column :shopping_carts,:shipping_email,:string
    add_column :shopping_carts,:shipping_subscribe,:boolean
    add_column :shopping_carts,:shipping_stripe_id,:string
  end
end
