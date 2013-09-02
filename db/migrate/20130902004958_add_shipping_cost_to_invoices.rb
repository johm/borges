class AddShippingCostToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices,:shipping_cost_in_cents,:integer
  end
end
