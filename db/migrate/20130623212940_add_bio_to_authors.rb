class AddBioToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :bio, :text
  end
end
