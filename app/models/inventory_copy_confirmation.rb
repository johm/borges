class InventoryCopyConfirmation < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :copy
  attr_accessible :status, :inventory_id,:copy_id
end
