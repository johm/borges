class AddTagToPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :purchase_orders,:tag,:string
  end
end
