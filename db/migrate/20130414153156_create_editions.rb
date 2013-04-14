class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :isbn13
      t.string :isbn10
      t.integer :year_of_publication
      t.string :format
      t.boolean :in_print
      t.text :notes
      t.references :title

      t.timestamps
    end
    add_index :editions, :title_id
  end
end
