class AddMissingIndexes < ActiveRecord::Migration

  def change
    add_index :editions, [:distributor_id, :title_id]
    add_index :shopping_carts, [:submitted,:deferred,:completed]
  end
end

