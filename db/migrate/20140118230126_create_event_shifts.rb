class CreateEventShifts < ActiveRecord::Migration
  def change
    create_table :event_shifts do |t|
      t.references :event_staffer
      t.references :event
      t.text :notes

      t.timestamps
    end
    add_index :event_shifts, :event_staffer_id
    add_index :event_shifts, :event_id
  end
end
