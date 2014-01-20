class AddMoreStuffToEvents < ActiveRecord::Migration
  def change
    add_column :events,:event_setup_starts,:datetime
    add_column :events,:event_breakdown_ends,:datetime

  end
end
