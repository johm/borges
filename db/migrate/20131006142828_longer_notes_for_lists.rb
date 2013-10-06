class LongerNotesForLists < ActiveRecord::Migration
  def change
    change_column :title_list_memberships,:notes,:text
  end
end
