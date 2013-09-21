class AddLayoutToPagesAndPostCategories < ActiveRecord::Migration
  def change
    add_column :pages,:layout,:string
    add_column :post_categories,:layout,:string
  end
end
