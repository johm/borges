class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :introduction
      t.text :body
      t.references :post_category
      t.boolean :published

      t.timestamps
    end
#   add_index :posts, :post_category_id
    add_index :posts, :slug, unique: true
    add_index :posts, :published
  end
end
