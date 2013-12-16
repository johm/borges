class MakePostsMultiple < ActiveRecord::Migration
  def change
    create_table :post_category_memberships do |t|
      t.references :post
      t.references :post_category

      t.timestamps
    end
    add_index :post_category_memberships, :post_id
    add_index :post_category_memberships, :post_category_id
  end

end
