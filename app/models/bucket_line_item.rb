class BucketLineItem < ActiveRecord::Base
  belongs_to :edition
  has_one :title, :through => :edition
  belongs_to :bucket, :touch => true
  belongs_to :customer
  attr_accessible :edition_id, :bucket_id, :customer_id,:customer,:notes

# do we need this?
# has_many :purchase_order_line_items 

#  validates :edition,:presence=>true # TK relax this for editionless items
  validates :bucket,:presence=>true

  default_scope includes(:title).order('titles.title asc')

  def isbn 
    if ! edition.nil?
      edition.isbn13 || edition.isbn10 || nil
    end
  end



  def as_json(options = {})
#    options[:methods] = :ext_price_string
    super(options)
  end


end
