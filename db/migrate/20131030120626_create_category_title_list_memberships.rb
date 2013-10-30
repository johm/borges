class CreateCategoryTitleListMemberships < ActiveRecord::Migration
  def change
    create_table :category_title_list_memberships do |t|
      t.references :title_list_id
      t.references :category_id
      t.integer :index

      t.timestamps
    end
    add_index :category_title_list_memberships, :title_list_id_id
    add_index :category_title_list_memberships, :category_id_id
  end
end
