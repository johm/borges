class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.text :introduction
      t.text :body
      t.references :parent

      t.timestamps
    end
    add_index :pages, :parent_id
    add_index :pages, :slug, unique: true

  end
end
