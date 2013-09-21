class AddOwnerToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices,:owner_id,:integer
  end
end
