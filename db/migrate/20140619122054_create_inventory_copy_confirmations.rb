class CreateInventoryCopyConfirmations < ActiveRecord::Migration
  def change
    create_table :inventory_copy_confirmations do |t|
      t.references :inventory
      t.references :copy
      t.boolean :status

      t.timestamps
    end
    add_index :inventory_copy_confirmations, :inventory_id
    add_index :inventory_copy_confirmations, :copy_id
  end
end
