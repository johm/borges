class AddStillMoreStuffAgainToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:needs_attention,:boolean
    add_index :shopping_carts,:needs_attention
    
  end
end
