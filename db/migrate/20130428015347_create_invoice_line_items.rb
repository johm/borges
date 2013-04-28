class CreateInvoiceLineItems < ActiveRecord::Migration
  def change
    create_table :invoice_line_items do |t|
      t.integer :quantity
      t.references :edition
      t.references :invoice
      t.references :purchase_order
      t.boolean :is_transfer
      t.float :discount

      t.timestamps
    end
    add_index :invoice_line_items, :edition_id
    add_index :invoice_line_items, :invoice_id
    add_index :invoice_line_items, :purchase_order_id
  end
end
