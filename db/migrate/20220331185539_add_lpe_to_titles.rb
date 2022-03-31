class AddLpeToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :lpe, :integer
  end
end
