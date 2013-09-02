class FixInvoiceLineItems < ActiveRecord::Migration
  def change
    rename_column :invoice_line_items, :purchase_order_id, :purchase_order_line_item_id
  end
end
