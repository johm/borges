class AddUserToSaleOrder < ActiveRecord::Migration
  def change
    add_column :sale_orders,:user_id,:integer
    add_index :sale_orders,:user_id
  end
end
