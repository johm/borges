class AddSalePriceCentsToSaleOrderLineItems < ActiveRecord::Migration
  def change
    add_column :sale_order_line_items,:sale_price_in_cents,:integer
  end
end
