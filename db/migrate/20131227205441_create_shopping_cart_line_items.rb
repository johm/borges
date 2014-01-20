class CreateShoppingCartLineItems < ActiveRecord::Migration
  def change
    create_table :shopping_cart_line_items do |t|
      t.references :shopping_cart
      t.references :edition
      t.integer :quantity
      t.integer :cost_in_cents

      t.timestamps
    end
    add_index :shopping_cart_line_items, :shopping_cart_id
    add_index :shopping_cart_line_items, :edition_id
  end
end
