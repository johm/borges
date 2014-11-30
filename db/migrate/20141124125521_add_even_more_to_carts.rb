class AddEvenMoreToCarts < ActiveRecord::Migration
  def change
    add_column :shopping_carts,:shipping_subscribed,:boolean
  end
end
