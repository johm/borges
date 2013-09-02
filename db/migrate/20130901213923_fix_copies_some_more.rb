class FixCopiesSomeMore < ActiveRecord::Migration
  def change
    remove_column :copies,:invoice_id
  end
end
