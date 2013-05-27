class AddDescriptionToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :description, :string
  end
end
