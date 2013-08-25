class AddIsHeroToPage < ActiveRecord::Migration
  def change
    add_column :pages,:is_hero,:boolean
  end
end
