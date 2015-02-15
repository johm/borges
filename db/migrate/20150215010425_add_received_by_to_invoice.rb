class AddReceivedByToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices,:received_by,:string
  end
end
