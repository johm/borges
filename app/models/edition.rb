class Edition < ActiveRecord::Base
 belongs_to :title,   :touch=>true
  has_many :copies
  has_many :purchase_order_line_items
  has_many :shopping_cart_line_items
  has_many :invoice_line_items
  

  
  has_many :distributors, :through => :copies

  belongs_to :publisher

  attr_accessible :format, :in_print, :isbn10, :isbn13, :notes, :year_of_publication, :list_price, :cover ,:publisher_id,:remote_cover_url,:publisher,:title_id,:number,:unavailable,:preorderable,:untaxed,:shipsfree

  validate :isbns_are_valid
  before_validation :normalize_isbns
  before_save :copy_isbns
  before_save :set_publisher_name
  mount_uploader :cover, ImageUploader

  monetize :list_price_cents
  default_value_for :list_price_cents, 0

  scope :published, where(:in_print => true)
  default_value_for :in_print, true

  scope :newest_first, order("year_of_publication desc")
  scope :without_edition, lambda {|e| e ? {:conditions => ["id != ?", e.id]} : {} }

  default_value_for :format, "Paperback"

  searchable do
    text :isbn10,:isbn13

    text :title do
      title.title rescue ""
    end
  end

  def as_json(*)
    super.tap do |hash|
      hash["instock"] = my_stock_status
      #libro.fm here
    end
  end
  
  
  def cover_image_url
    cover_url(:medium)
  end
  
  def opengraph_image_url
    cover_url(:opengraph)
  end

  
  def edition_string
    "#{id} #{format} #{isbn13}"
  end

  def can_preorder?
    if preorderable?  && copies.length == 0  && ! unavailable? # it should be a back order if we already have seen copies!
      true
    else 
      false
    end
    
  end

  def can_back_order?
    false
#    if in_print? && ! unavailable?  # don't let people order things that are marked as out of print or unavailable
#      true
#    else
#      false
#    end
  end

  def has_copies_in_stock?
    copies.where("status"=>"STOCK").length > 0
  end

  def last_distributor 
    copies.last.invoice.distributor rescue nil 
  end

  def my_stock_status
    if has_copies_in_stock? 
      "IN STOCK" 
    elsif unavailable?
      "UNAVAILABLE"
    elsif preorderable?
      "PREORDER"
    elsif in_print? 
      if ENV["DISTRIBUTORSWEORDERFROMFREQUENTLY"] && last_distributor && (YAML.load(ENV["DISTRIBUTORSWEORDERFROMFREQUENTLY"]).include? last_distributor.name) && (copies.last.inventoried_when > (DateTime.now - 6.months))
          "OUT OF STOCK" # "SHIPS IN 2-4 WEEKS" # "SHIPS IN 5-7 DAYS"
      else
         "OUT OF STOCK" #  "SHIPS IN 2-4 WEEKS"
      end
    else 
      "OUT OF PRINT"
    end
  end

  def needed_for_online
    shopping_cart_line_items.includes(:shopping_cart).inject(0) do |sum,li|
      if li.shopping_cart && li.shopping_cart.ordered? && ! ( li.shopping_cart.sold_through || li.shopping_cart.completed)
        sum+li.quantity
      else 
        sum
      end
    end
  end
  

  def my_online_price
    if copies.length > 0
      has_copies_in_stock? ? copies.where("status"=>"STOCK").order("price_in_cents desc").first.price : copies.order("price_in_cents desc").first.price
    else
      list_price
    end
  end

  def self.formats
    ['Hardcover','Paperback','Pamphlet','Magazine','Journal','CD','DVD','Clothing','Coffee','Other','Ships free','Pickup only']
  end

  def to_s
    "#{number}  (#{format} #{year_of_publication})"
  end

  def isbn
    isbn13
  end

  def isbns_are_valid
    unless isbn10.blank? || Lisbn.new(isbn10).valid?
      errors.add(:isbn10,"Not valid")
    end

    unless isbn13.blank? || Lisbn.new(isbn13).valid?
      errors.add(:isbn13,"Not valid")
    end
  end

  def copy_isbns
    if isbn10.blank? && !isbn13.blank?
      self.isbn10=Lisbn.new(isbn13).isbn10
    end
    if isbn13.blank? && !isbn10.blank?
      self.isbn13=Lisbn.new(isbn10).isbn13
    end
  end

  def set_publisher_name
    self.publisher_name=publisher.name rescue ""
  end

  
  protected
  def normalize_isbns
    isbn10.gsub!(/[^0-9X]/,'') unless isbn10.nil?
    isbn13.gsub!(/[^0-9X]/,'') unless isbn13.nil?
  end
end
