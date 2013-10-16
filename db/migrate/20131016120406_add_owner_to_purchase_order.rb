class AddOwnerToPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :purchase_orders,:owner_id,:integer
  end
end
