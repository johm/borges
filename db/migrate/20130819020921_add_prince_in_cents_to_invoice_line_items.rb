class AddPrinceInCentsToInvoiceLineItems < ActiveRecord::Migration
  def change
    add_column :invoice_line_items,:price_in_cents,:integer
  end
end
