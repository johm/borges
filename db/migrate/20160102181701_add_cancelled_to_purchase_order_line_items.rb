class AddCancelledToPurchaseOrderLineItems < ActiveRecord::Migration
  def change
    add_column :purchase_order_line_items,:cancelled,:integer
  end
end
