class AddStillMoreStuffToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:pickup_notify,:boolean
    add_index :shopping_carts,:pickup_notify
    
  end
end
