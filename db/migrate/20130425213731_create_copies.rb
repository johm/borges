class CreateCopies < ActiveRecord::Migration
  def change
    create_table :copies do |t|
      t.references :edition
      t.integer :cost_in_cents
      t.integer :price_in_cents
      t.text :notes
      t.references :distributor
      t.references :owner
      t.boolean :is_used

      t.timestamps
    end
    add_index :copies, :edition_id
    add_index :copies, :distributor_id
    add_index :copies, :owner_id
  end
end
