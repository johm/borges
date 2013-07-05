class AddFieldsToCopy < ActiveRecord::Migration
  def change
    add_column :copies, :inventoried_when, :datetime
    add_column :copies, :deinventoried_when, :datetime
    add_column :copies, :status, :string
    
  end
end
