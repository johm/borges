class FixPublisher < ActiveRecord::Migration
  def change
    remove_column :titles, :publisher_id
    add_column :editions,:publisher_id,:integer
    add_index :editions,:publisher_id
  end
end
