class AddStatusFlagsToEditions < ActiveRecord::Migration
  def change
    add_column :editions,:preorderable,:boolean
    add_column :editions,:unavailable,:boolean
  end
end
