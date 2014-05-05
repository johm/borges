class ReturnOrder < ActiveRecord::Base
  has_many :return_order_line_items
  attr_accessible :posted,:notes,:distributor_id
  belongs_to :distributor #where the books came from

  default_scope  includes(:return_order_line_items)

  def total
    return_order_line_items.inject(Money.new(0)) {|sum,roli| roli.copy.nil? ? sum : sum+roli.copy.cost }
  end

  def line_item_editions_with_counts 
    item_count=return_order_line_items.inject(Hash.new(0)){|h,e| h[e.copy.edition.isbn13 || e.copy.edition.id] += 1 ; h}
    items_by_isbn_or_id=return_order_line_items.inject(Hash.new(0)){|h,e| h[e.copy.edition.isbn13 || e.copy.edition.id] = e.copy.edition ; h}
    items_by_isbn_or_id.keys.collect {|k| [item_count[k],items_by_isbn_or_id[k]] }
 end

  def number 
    id
  end

end
