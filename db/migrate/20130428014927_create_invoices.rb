class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :distributor
      t.text :notes
      t.string :number

      t.timestamps
    end
    add_index :invoices, :distributor_id
  end
end
