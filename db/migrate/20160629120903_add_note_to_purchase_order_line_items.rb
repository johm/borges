class AddNoteToPurchaseOrderLineItems < ActiveRecord::Migration
  def change
    add_column :purchase_order_line_items,:notes,:text
  end
end
