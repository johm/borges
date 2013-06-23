class AddIntroductionToTitle < ActiveRecord::Migration
  def change
    add_column :titles, :introduction, :text
  end
end
