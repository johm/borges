class AddStuffToShoppingCarts < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:submitted_when,:datetime
    add_column :shopping_carts,:deferred,:boolean
    add_column :shopping_carts,:completed_when,:datetime
    add_column :shopping_carts,:completed,:boolean
  end
end
