class CreateSaleOrderLineItems < ActiveRecord::Migration
  def change
    create_table :sale_order_line_items do |t|
      t.references :sale_order
      t.references :copy

      t.timestamps
    end
    add_index :sale_order_line_items, :sale_order_id
    add_index :sale_order_line_items, :copy_id
  end
end
