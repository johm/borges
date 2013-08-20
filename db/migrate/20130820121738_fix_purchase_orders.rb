class FixPurchaseOrders < ActiveRecord::Migration
  def change
    remove_column :purchase_orders, :customer_id
    add_column :purchase_order_line_items, :customer_id, :integer
    add_index :purchase_order_line_items, :customer_id
  end
end
