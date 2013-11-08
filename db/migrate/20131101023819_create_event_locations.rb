class CreateEventLocations < ActiveRecord::Migration
  def change
    create_table :event_locations do |t|
      t.string :title
      t.string :url
      t.text :address
      t.text :description

      t.timestamps
    end
  end
end
