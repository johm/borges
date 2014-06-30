class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :name
      t.text :notes

      t.timestamps
    end
  end
end
