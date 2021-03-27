class AddPaymentIntentToShoppingCarts < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:payment_intent,:string
    add_index :shopping_carts,:payment_intent
  end
end
