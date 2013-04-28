class AddInvoiceToCopies < ActiveRecord::Migration
  def change
    add_column :copies,:invoice_id,:integer
    add_index :copies,:invoice_id
  end
end
