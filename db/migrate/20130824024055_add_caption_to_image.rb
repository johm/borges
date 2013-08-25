class AddCaptionToImage < ActiveRecord::Migration
  def change
    add_column :images,:description,:text
  end
end
