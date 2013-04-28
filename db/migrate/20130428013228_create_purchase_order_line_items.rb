class CreatePurchaseOrderLineItems < ActiveRecord::Migration
  def change
    create_table :purchase_order_line_items do |t|
      t.integer :quantity
      t.references :edition
      t.references :purchase_order

      t.timestamps
    end
    add_index :purchase_order_line_items, :edition_id
    add_index :purchase_order_line_items, :purchase_order_id
  end
end
