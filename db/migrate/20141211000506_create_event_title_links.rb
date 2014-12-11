class CreateEventTitleLinks < ActiveRecord::Migration
  def change
    create_table :event_title_links do |t|
      t.references :event
      t.references :title
      
      t.timestamps
    end
    add_index :event_title_links, :event_id
    add_index :event_title_links, :title_id
  end
end
