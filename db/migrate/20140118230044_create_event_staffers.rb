class CreateEventStaffers < ActiveRecord::Migration
  def change
    create_table :event_staffers do |t|
      t.text :name
      t.text :email

      t.timestamps
    end
  end
end
