class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :the_image
      t.references :imagey, :polymorphic => true
      
      t.timestamps
    end
  end
end
