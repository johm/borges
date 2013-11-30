class ReturnOrder < ActiveRecord::Base
  has_many :return_order_line_items
  attr_accessible :posted,:notes,:distributor_id
  belongs_to :distributor #where the books came from

  default_scope  includes(:return_order_line_items)

  def total
    return_order_line_items.inject(Money.new(0)) {|sum,roli| sum+roli.copy.cost }
  end

end
