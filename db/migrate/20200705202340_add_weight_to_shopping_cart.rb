class AddWeightToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:weight,:integer
    add_column :shopping_carts,:easypost_shipment_id,:string
  end
end
