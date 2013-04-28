class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string :number
      t.text :notes
      t.references :customer
      t.references :distributor
      t.boolean :ordered
      t.datetime :ordered_when

      t.timestamps
    end
    add_index :purchase_orders, :customer_id
    add_index :purchase_orders, :distributor_id
  end
end
