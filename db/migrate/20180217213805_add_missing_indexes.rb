class AddMissingIndexes < ActiveRecord::Migration

  def change
    add_index :shopping_carts, [:submitted,:deferred,:completed]
  end
end

