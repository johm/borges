class Edition < ActiveRecord::Base
  belongs_to :title
  has_many :copies
  has_many :purchase_order_line_items
  attr_accessible :format, :in_print, :isbn10, :isbn13, :notes, :year_of_publication

  validate :isbns_are_valid
  before_validation :normalize_isbns
  before_save :copy_isbns
  mount_uploader :cover, ImageUploader


  def self.formats
    ['Hardcover','Paperback','Pamphlet']
  end

  def to_s
    "#{format} (#{year_of_publication})"
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
    isbn10.gsub!(/[^0-9X]/,'')
    isbn13.gsub!(/[^0-9X]/,'')
  end


end
