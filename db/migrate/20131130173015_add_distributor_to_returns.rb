class AddDistributorToReturns < ActiveRecord::Migration
  def change
    add_column :return_orders,:distributor_id,:integer
  end
end
