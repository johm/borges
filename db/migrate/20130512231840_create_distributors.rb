class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
      t.string :name
      t.string :our_account_number
      t.text :notes

      t.timestamps
    end
  end
end
