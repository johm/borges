class Bucket < ActiveRecord::Base
  # there should be a mechanism by which purchase order line items can be checked off against invoices
  validates :name, :uniqueness => true
  validates :name, :presence => true

  attr_reader   :editions #getter
  attr_writer   :editions #setter
  attr_accessor :editions #both
  
  has_many :bucket_line_items,dependent: :destroy
  attr_accessible :notes, :name, :tag,:editions

  default_scope  includes(:bucket_line_items)
  
  def self.tags
    ['General','Frontlist','Events and Tabling','Special orders','Section stock','Vendor stock','Bookseller favs']
  end
    


  def last_order 
    bucket_line_items.collect {|bli| bli.edition ? bli.edition.last_order_date : nil }.find_all {|x| ! x.nil?}.sort.last
  end


 def number_of_editions
    bucket_line_items.size
 end

 
 def number_of_editions_in_stock 
   bucket_line_items.inject(0) {|sum,li| sum + (li.edition.has_copies_in_stock? ? 1 : 0 rescue 0)}
 end



  def as_json(options = {})
#    options[:methods] = :estimated_total_string
    super(options)
  end

  def process_upload
    if editions.nil? 
      "No file uploaded"
    else    
      begin
        CSV.read(editions.tempfile, headers: true).collect {|row| process_upload_row(row)}.join(" #### ")
      rescue
        
        "No rows processed"
      end
    end
  end

  def process_upload_row(row)
    isbn=row["ean"] || row["EAN"]
    edition = Edition.where('isbn13 = ? or isbn10 = ?',isbn,isbn).first
    if edition.nil? 
      title=Title.new
      title.title=row["Title"]

      edition=Edition.new
      edition.isbn13=isbn
      edition.publisher=Publisher.find_or_create_by_name(row["Publisher Name"])
      edition.format="Hardcover" if row["Format Description"].include?("Hardcover")
      edition.list_price=row["List Price"]
      edition.year_of_publication=row["PubDate"].split("/").last
      title.contributions=["Author","Author 2"].collect {|a| Contribution.new(:author=>Author.find_or_create_by_full_name(row[a].split(", ").reverse.join(" "))) unless row[a].blank?}.find_all {|x| !x.nil?}
      
      title.editions << edition
      edition.save! 
      title.save!
    else
    end
      li=BucketLineItem.new(:notes => "Edelweiss")
      li.edition=edition

 
      bucket_line_items << li 

      "#{edition.title.title} added to bucket."
    
  end

end

