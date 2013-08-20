class AddReceivedToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices,:received,:boolean
    add_column :invoices,:received_when,:datetime
  end
end
