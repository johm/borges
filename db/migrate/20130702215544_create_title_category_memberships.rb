class CreateTitleCategoryMemberships < ActiveRecord::Migration
  def change
    create_table :title_category_memberships do |t|
      t.references :title
      t.references :category

      t.timestamps
    end
    add_index :title_category_memberships, :title_id
    add_index :title_category_memberships, :category_id
  end
end
