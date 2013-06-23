class AddPublishedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :published, :boolean
    add_index :pages, :published
  end
end
