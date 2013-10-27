class AddIsGridToPages < ActiveRecord::Migration
  def change
    add_column :pages, :is_image_grid, :boolean
  end
end
