class AddEvenMoreStuffToShoppingCarts < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:pulled,:boolean
    add_index :shopping_carts,:pulled
    add_column :shopping_carts,:sold_through,:boolean
    add_index :shopping_carts,:sold_through
    add_column :shopping_carts,:shipped,:boolean
    add_index :shopping_carts,:shipped
    add_column :shopping_carts,:picked_up,:boolean
    add_index :shopping_carts,:picked_up
    add_column :shopping_carts,:is_preorder,:boolean
    add_index :shopping_carts,:is_preorder
  end
end
