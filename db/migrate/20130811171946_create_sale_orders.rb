class CreateSaleOrders < ActiveRecord::Migration
  def change
    create_table :sale_orders do |t|
      t.boolean :from_pos
      t.boolean :from_web
      t.string :customer_po
      t.references :customer
      t.integer :total_in_cents
      t.boolean :posted
      t.integer :discount_percent
      t.integer :tax_amount_in_cents

      t.timestamps
    end
    add_index :sale_orders, :customer_id
  end
end
