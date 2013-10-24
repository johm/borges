class Title < ActiveRecord::Base
  attr_accessible :title,:contributions_attributes,:authors_attributes,:editions_attributes,:description,:introduction, :title_list_memberships_attributes,:title_category_memberships_attributes

  searchable do
    text :title,:introduction,:description
    text :authors do
      authors.map { |a| a.full_name }
    end  
    text :publisher do
      editions.map { |e| e.publisher }
    end  
    text :distributor do
      copies.map { |c| c.invoice_line_item.invoice.distributor unless c.invoice_line_item.nil? }
    end  
    
    text :isbn do
      editions.map {|e| "#{e.isbn13} #{e.isbn10}"}
    end

    integer :copies_sold do
      copies.where(status: "SOLD").length
    end

    integer :copies_in_stock do  
      copies.where(status: "STOCK").length
    end


  end

  has_many :contributions
  has_many :authors, :through => :contributions
  has_many :editions 
  has_many :copies, :through => :editions
  has_many :purchase_order_line_items, :through => :editions
  has_many :title_lists,:through => :title_list_memberships
  has_many :title_list_memberships
  has_many :post_title_links
  has_many :posts, :through => :post_title_links 
  has_many :title_category_memberships
  has_many :categories,:through => :title_category_memberships
 
  accepts_nested_attributes_for :contributions, :allow_destroy => true
  accepts_nested_attributes_for :editions, :allow_destroy => true
  accepts_nested_attributes_for :title_list_memberships, :allow_destroy => true    
  accepts_nested_attributes_for :title_category_memberships, :allow_destroy => true    

  def to_s
    title
  end

  def title_and_id
    "#{title} (#{id})"
  end

  def latest_edition
    editions.newest_first.first
  end

  def latest_edition?
    latest_edition
  end

  def latest_published_edition
    editions.published.newest_first.first || latest_edition
  end

  def by_the_same_authors 
    authors.collect {|a| a.titles}.flatten.find_all {|t| t.id != self.id}.uniq.sort_by {|x| x.title}
  end

  [:authors, :publisher, :distributor,:copies_sold_or_more,:copies_sold_or_less,:copies_stock_or_more,:copies_stock_or_less].each do |attr|
  define_method("my_#{attr}") do
      ""
    end
  end
  

  def in_stock
    copies.find_all {|c| c.status=="STOCK"}.length
  end

  def sold
    copies.find_all {|c| c.status=="SOLD"}.length
  end

  def on_order 
    purchase_order_line_items.inject(0) do |sum,li| 
      if li.purchase_order.ordered? 
        sum+li.quantity-li.received
      else 
        sum
      end
    end 

  end
  

  def probably_on_order 
    purchase_order_line_items.inject(0) do |sum,li| 
      if li.purchase_order.ordered? 
        sum
      else
        sum+li.quantity-li.received
      end
    end
  end
  

end
