class Title < ActiveRecord::Base
  attr_accessible :title,:contributions_attributes,:authors_attributes,:editions_attributes,:description,:introduction, :title_list_memberships_attributes,:title_category_memberships_attributes

  searchable do
    text :title,:introduction,:description
    text :authors do
      authors.map { |a| a.full_name }
    end  

    integer :category_count do 
      categories.length
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

    integer :year_of_publication, :multiple => true do
      editions.map {|e| e.year_of_publication }
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

  def slug
    title.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/-$/,"")   
  end

  def to_param
    "#{id}-#{slug}"
  end

  def to_s
    title
  end

  def title_and_id
    "#{title} (#{id})"
  end

  def latest_edition
    Rails.cache.fetch("/title/#{id}-#{updated_at}/latest_edition", :expires_in => 12.hours) do
      editions.newest_first.first
    end
  end

  def latest_edition?
    latest_edition
  end

  def latest_published_edition
    Rails.cache.fetch("/title/#{id}-#{updated_at}/latest_published_edition", :expires_in => 12.hours) do
      editions.published.newest_first.first || latest_edition
    end
  end

  def by_the_same_authors 
    authors.collect {|a| a.titles}.flatten.find_all {|t| t.id != self.id}.uniq.sort_by {|x| x.title}
  end

  [:authors, :publisher, :distributor,:copies_sold_or_more,:copies_sold_or_less,:copies_stock_or_more,:copies_stock_or_less].each do |attr|
  define_method("my_#{attr}") do
      ""
    end
  end
  
  def last_distributor 
    copies.last.invoice.distributor rescue nil 
  end

  def in_stock
    copies.instock.length
  end

  def sold
    copies.find_all {|c| c.status=="SOLD"}.length
  end

  def on_order 
    purchase_order_line_items.includes(:purchase_order).inject(0) do |sum,li| 
      if ! li.purchase_order.nil? && li.purchase_order.ordered? 
        [0,sum+li.quantity-li.received].max
      else 
        sum
      end
    end 

  end
  

  def probably_on_order 
    purchase_order_line_items.includes(:purchase_order).inject(0) do |sum,li| 
      if li.purchase_order.nil? || li.purchase_order.ordered?
        sum
      else
        sum+li.quantity-li.received
      end
    end
  end
  
  def outstandingorderlines
    purchase_order_line_items.find_all {|x| ! x.purchase_order.nil?  && x.quantity-x.received > 0}
  end

  def whichorders 
    begin
      purchase_order_line_items.includes(:purchase_order).collect do |x|
        if x.purchase_order.nil?  || (x.quantity-x.received <= 0)
          nil
        else 
          "#{x.quantity-x.received} on #{x.purchase_order.number}"
        end
      end.join("|")
    rescue
      "PROBLEM WITH TITLE self.id"
    end
  end

  def is_in_print?
    editions.index {|e| e.in_print?}.nil? ? false : true  
  end
  
  def is_in_stock?
    in_stock > 0
  end

  def is_preorderable? 
    editions.index {|e| e.can_preorder?}.nil? ? false : true  #only want titles that have an edition which has not been released
  end
  
  def is_unavailable? 
    editions.index {|e| ! e.unavailable?}.nil? ? true : false  
  end


  def availability
    if is_in_stock? 
      "IN STOCK" 
    elsif is_preorderable?
      "PREORDER"
    elsif is_unavailable?
      "UNAVAILABLE"
    elsif is_in_print? 
      if ENV["DISTRIBUTORSWEORDERFROMFREQUENTLY"] && last_distributor && (YAML.load(ENV["DISTRIBUTORSWEORDERFROMFREQUENTLY"]).include? last_distributor.name) && (copies.last.inventoried_when > (DateTime.now - 6.months))
        "OUT OF STOCK" # "SHIPS IN 2-4 WEEKS" # "SHIPS IN 5-7 DAYS"
      else
          "OUT OF STOCK" # "SHIPS IN 2-4 WEEKS"
      end
    else 
      "OUT OF PRINT"
    end
  end

  def copies_info 
    copies.instock.collect {|c| "$#{c.price} [#{c.edition.isbn}]" }.join("\n")
  end


  def net_profit_or_loss
    cost=copies.inject(Money.new(0)) {|sum,c| sum+c.cost} 
    income=copies.sold.inject(Money.new(0)) {|sum,c| sum+c.price} 
    returned=copies.returned.inject(Money.new(0)) {|sum,c| sum+c.cost} 
    income-cost+returned
  end

  def hundreds_of_dollars 
    n=(net_profit_or_loss.to_f/100).floor 
    n > 0 ? n : 0
  end

  def average_time_on_shelf
    #copies in stock---how many days ago were they received?
    #copies sold---how many days did they take to sell?
    #copies lost---how many days did they take to lose?
    stock_on_shelves_for=copies.instock.inject(0) {|sum,c| sum + (DateTime.now.to_date.mjd - c.inventoried_when.to_date.mjd)}
    took_this_long_to_sell=copies.sold.inject(0) {|sum,c| sum + (c.deinventoried_when.to_date.mjd - c.inventoried_when.to_date.mjd)}
    took_this_long_to_lose=copies.lost.inject(0) {|sum,c| sum + ((c.deinventoried_when.to_date.mjd rescue c.updated_at.to_date.mjd ) - c.inventoried_when.to_date.mjd)}

    #ignore returned copies
    #add the three numbers, divide by number of copies sold or in stock or lost
    
    (stock_on_shelves_for+took_this_long_to_sell+took_this_long_to_lose) / (copies.instock.count+copies.sold.count+copies.lost.count) rescue 0 #in case we don't have any copies at all?

  end
  
  def hotness 
    if average_time_on_shelf <= 0 || average_time_on_shelf > 100
      0
    else
      (((100-average_time_on_shelf)/10) * (2*copies.sold.length/copies.length)).ceil  rescue 0
    end

    # number of copies sold in less than 7 days
#    begin
 #     copies.sold.find_all {|c| (c.deinventoried_when.to_date.mjd - c.inventoried_when.to_date.mjd) < 7}.length 
 #   rescue 
  #    0
  #  end
  end

end
