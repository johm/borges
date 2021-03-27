class AddStillMoreStuffToShoppingCartAgain < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:payment_status,:string
    add_index :shopping_carts,:payment_status
  end
end
