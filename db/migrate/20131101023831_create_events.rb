class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.references :event_location
      t.datetime :event_start
      t.datetime :event_end
      t.boolean :published

      t.timestamps
    end
    add_index :events, :event_location_id
  end
end
