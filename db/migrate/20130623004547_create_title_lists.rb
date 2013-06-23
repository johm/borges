class CreateTitleLists < ActiveRecord::Migration
  def change
    create_table :title_lists do |t|
      t.string :name
      t.text :description
      t.boolean :public

      t.timestamps
    end
  end
end
