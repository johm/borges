class AddShippingAndTaxToEditions < ActiveRecord::Migration
  def change
    add_column :editions,:shipsfree,:boolean
    add_column :editions,:untaxed,:boolean
  end
end
