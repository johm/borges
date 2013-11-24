class AddNumberToEdition < ActiveRecord::Migration
  def change
    add_column :editions,:number,:text
  end
end
