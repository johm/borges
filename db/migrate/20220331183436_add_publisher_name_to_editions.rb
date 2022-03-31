class AddPublisherNameToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :publisher_name, :text
  end
end
