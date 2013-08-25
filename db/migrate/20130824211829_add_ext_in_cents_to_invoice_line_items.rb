class AddExtInCentsToInvoiceLineItems < ActiveRecord::Migration
  def change
    add_column :invoice_line_items, :ext_in_cents, :integer
  end
end
