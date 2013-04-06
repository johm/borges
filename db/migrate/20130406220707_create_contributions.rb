class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :author_id
      t.integer :title_id
      t.string :what

      t.timestamps
    end
  end
end
