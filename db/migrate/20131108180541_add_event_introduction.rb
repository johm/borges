class AddEventIntroduction < ActiveRecord::Migration
  def change
    add_column :events,:introduction,:text
  end

end
