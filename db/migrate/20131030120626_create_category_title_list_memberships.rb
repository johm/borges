class CreateCategoryTitleListMemberships < ActiveRecord::Migration
  def change
    create_table :category_title_list_memberships do |t|
      t.references :title_list
      t.references :category
      t.integer :position

      t.timestamps
    end
    add_index :category_title_list_memberships, :title_list_id
    add_index :category_title_list_memberships, :category_id
  end
end
