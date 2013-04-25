class Copy < ActiveRecord::Base
  belongs_to :edition
  delegate :title, :to => :edition
  belongs_to :distributor
  belongs_to :owner
  attr_accessible :cost_in_cents, :is_used, :notes, :price_in_cents
end
