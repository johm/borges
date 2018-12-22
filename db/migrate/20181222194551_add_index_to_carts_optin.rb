class AddIndexToCartsOptin < ActiveRecord::Migration
  def change
    add_index :shopping_carts, [:shipping_subscribe
]            
  end
end
