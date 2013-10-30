class Category < ActiveRecord::Base
  attr_accessible :description, :image, :name
  has_many :title_category_memberships
  has_many :titles,:through => :title_category_memberships
  has_many :title_lists, :through => :category_title_list_memberships

  mount_uploader :image, ImageUploader

  def titles_in_stock
    titles.find_all {|t| t.in_stock > 0 }.length
  end
  
  def copies_sold
    titles.inject(0) {|sum,t| sum + t.sold}
  end
  

  def total_titles
    titles.length
  end
  
  def to_s
    name
  end
  
  
end
