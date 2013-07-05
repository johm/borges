class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.text :notes

      t.timestamps
    end
  end
end
