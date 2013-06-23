class CreatePostTitleLinks < ActiveRecord::Migration
  def change
    create_table :post_title_links do |t|
      t.references :post
      t.references :title

      t.timestamps
    end
    add_index :post_title_links, :post_id
    add_index :post_title_links, :title_id
  end
end
