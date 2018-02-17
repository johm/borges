class AddAnotherMissingIndex < ActiveRecord::Migration
  def change

    add_index :shopping_carts, [:created_at]            
  end
end
