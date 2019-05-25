class AddWithFriendsToEvents < ActiveRecord::Migration
  def change
    add_column :events,:withfriends_url,:text
  end
end
