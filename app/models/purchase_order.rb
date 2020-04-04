

class PurchaseOrder < ActiveRecord::Base
  # there should be a mechanism by which purchase order line items can be checked off against invoices
  validates :number, :uniqueness => true
  validates :number, :presence => true

  attr_reader   :editions #getter
  attr_writer   :editions #setter
  attr_accessor :editions #both
  
  belongs_to :distributor #where the books came from
  belongs_to :owner #who gets the books

  has_many :purchase_order_line_items,dependent: :destroy
  attr_accessible :notes, :number, :ordered, :ordered_when,:order_by_when, :distributor_id,:owner_id,:tag,:editions

  default_scope  includes(:purchase_order_line_items)
  
  def self.tags
    ['Normal','Frontlist','Course books','Event order','Tabling order','Special order','Used books','Remainders']
  end
    


  def estimated_total
    purchase_order_line_items.inject(Money.new(0)) {|sum,li| sum+li.ext_price   }
  end
 
  def estimated_total_string
    purchase_order_line_items.inject(Money.new(0)) {|sum,li| sum+li.ext_price   }.to_s
  end

 def number_of_copies
    purchase_order_line_items.inject(0) {|sum,li| sum+li.quantity}
 end

 
 def outstanding 
   purchase_order_line_items.inject(0) {|sum,li| sum+li.quantity-li.received rescue 0}
 end

 def cancel 
   purchase_order_line_items.each {|poli| poli.cancel}
 end


  def as_json(options = {})
    options[:methods] = :estimated_total_string
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
      li=PurchaseOrderLineItem.new(:quantity => 1, :notes => "Edelweiss",:received => 0)
      li.edition=edition

 
      purchase_order_line_items << li 

      "#{edition.title.title} added to purchase order."
    

  end

end

