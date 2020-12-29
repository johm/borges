class CreateTextFragments < ActiveRecord::Migration
  def change
    create_table :text_fragments do |t|
      t.string :name
      t.text :sometext

      t.timestamps
    end
  end
end
