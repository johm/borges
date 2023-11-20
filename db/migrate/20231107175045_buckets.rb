class Buckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.text :name
      t.text :notes
      t.text :tag
      t.timestamps
    end

    create_table :bucket_line_items do |t|
      t.references :edition
      t.references :customer
      t.references :bucket
      t.text :notes
      
    end
    
    add_index :bucket_line_items, :bucket_id

  end
end
