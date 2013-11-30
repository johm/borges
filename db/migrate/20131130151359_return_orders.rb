class ReturnOrders < ActiveRecord::Migration
  def change
    create_table :return_orders do |t|
      t.boolean :posted
      t.datetime :posted_when
      t.text :notes
      t.timestamps
    end

    create_table :return_order_line_items do |t|
      t.references :return_order
      t.references :copy
      t.timestamps
    end

    add_index :return_order_line_items, :return_order_id
    add_index :return_order_line_items, :copy_id
    add_index :return_orders, :posted

  end

end
