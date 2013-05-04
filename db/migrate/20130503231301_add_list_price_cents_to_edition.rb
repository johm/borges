class AddListPriceCentsToEdition < ActiveRecord::Migration
  def change
    add_column :editions,:list_price_cents,:integer
  end
end
