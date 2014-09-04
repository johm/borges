class AddMoreStuffToShoppingCarts < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:shipping_phone,:string
    add_column :shopping_carts,:shipping_address_type,:string
    add_column :shopping_carts,:shipping_ok_to_leave,:string
    add_column :shopping_carts,:shipping_notes,:text
  end
end
