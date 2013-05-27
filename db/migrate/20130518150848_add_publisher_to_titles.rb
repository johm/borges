class AddPublisherToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :publisher_id, :integer
    add_index :titles, :publisher_id
  end
end    

