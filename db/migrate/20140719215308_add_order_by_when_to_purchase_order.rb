class AddOrderByWhenToPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :purchase_orders,:order_by_when,:datetime
  end
end
