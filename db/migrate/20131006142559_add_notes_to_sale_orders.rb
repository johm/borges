class AddNotesToSaleOrders < ActiveRecord::Migration
  def change
    add_column :sale_orders,:notes,:text
  end
end
