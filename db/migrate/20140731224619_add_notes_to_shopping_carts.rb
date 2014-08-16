class AddNotesToShoppingCarts < ActiveRecord::Migration
  def change
        add_column :shopping_carts,:notes,:text
  end
end
