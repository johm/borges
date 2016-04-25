class Edition < ActiveRecord::Base
 belongs_to :title,   :touch=>true
  has_many :copies
  has_many :purchase_order_line_items
  has_many :invoice_line_items

  has_many :distributors, :through => :copies

  belongs_to :publisher

  attr_accessible :format, :in_print, :isbn10, :isbn13, :notes, :year_of_publication, :list_price, :cover ,:publisher_id,:remote_cover_url,:publisher,:title_id,:number

  validate :isbns_are_valid
  before_validation :normalize_isbns
  before_save :copy_isbns
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

  def can_back_order?
    if in_print?
      true
    else
      false
    end
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
    elsif in_print? 
      if ENV["DISTRIBUTORSWEORDERFROMFREQUENTLY"] && last_distributor && (YAML.load(ENV["DISTRIBUTORSWEORDERFROMFREQUENTLY"]).include? last_distributor.name) && (copies.last.inventoried_when > (DateTime.now - 6.months))
        "SHIPS IN 5-7 DAYS"
      else
        "SHIPS IN 2-4 WEEKS"
      end
    else 
      "OUT OF PRINT"
    end
  end



  def my_online_price
    has_copies_in_stock? ? copies.where("status"=>"STOCK").order("price_in_cents desc").first.price : copies.order("price_in_cents desc").first.price
  end

  def self.formats
    ['Hardcover','Paperback','Pamphlet','Magazine','Journal','CD','DVD','Clothing','Coffee','Other','Ships free']
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

  protected
  def normalize_isbns
    isbn10.gsub!(/[^0-9X]/,'') unless isbn10.nil?
    isbn13.gsub!(/[^0-9X]/,'') unless isbn13.nil?
  end
end
