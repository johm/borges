class MissingIndex < ActiveRecord::Migration
  def change
    add_index :return_orders, :distributor_id
  end
end
