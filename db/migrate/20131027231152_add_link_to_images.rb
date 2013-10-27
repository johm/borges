class AddLinkToImages < ActiveRecord::Migration
  def change
    add_column :images, :link, :string
  end
end
