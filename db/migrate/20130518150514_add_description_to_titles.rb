class AddDescriptionToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :description, :text
  end
end
