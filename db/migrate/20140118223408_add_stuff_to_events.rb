class AddStuffToEvents < ActiveRecord::Migration
  def change
    add_column :events,:show_on_red_emmas_page,:boolean
    add_column :events,:show_on_2640_page,:boolean
    add_column :events,:internal_notes,:text
  end
end
