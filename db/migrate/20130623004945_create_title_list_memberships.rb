class CreateTitleListMemberships < ActiveRecord::Migration
  def change
    create_table :title_list_memberships do |t|
      t.references :title
      t.references :title_list
      t.string :notes

      t.timestamps
    end
    add_index :title_list_memberships, :title_id
    add_index :title_list_memberships, :title_list_id
  end
end
