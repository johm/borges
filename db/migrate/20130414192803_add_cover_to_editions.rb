class AddCoverToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :cover, :string
  end
end
