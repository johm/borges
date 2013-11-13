class AddPostedWhenToSaleOrder < ActiveRecord::Migration
  def change
    add_column :sale_orders,:posted_when,:datetime
  end
end
