class CreatePostTitleListLinks < ActiveRecord::Migration
  def change
    create_table :post_title_list_links do |t|
      t.references :post
      t.references :title_list

      t.timestamps
    end
    add_index :post_title_list_links, :post_id
    add_index :post_title_list_links, :title_list_id
  end
end
