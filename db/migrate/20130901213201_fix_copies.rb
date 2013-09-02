class FixCopies < ActiveRecord::Migration
  def change
    remove_column :copies,:distributor_id
    add_column :copies,:invoice_line_item_id,:integer
  end

end
