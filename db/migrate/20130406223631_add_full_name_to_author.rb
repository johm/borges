class AddFullNameToAuthor < ActiveRecord::Migration
  def change
    add_column :authors,:full_name,:string
  end
end
