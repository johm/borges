class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.string :session_id
      t.string :submitted
      t.string :shipping_name
      t.string :shipping_address_1
      t.string :shipping_address_2
      t.string :shipping_state
      t.string :shipping_city
      t.string :shipping_zip

      t.timestamps
    end
  end
end
