class Category < ActiveRecord::Base
  attr_accessible :description, :image, :name,:remote_image_url, :category_title_list_memberships_attributes
  has_many :title_category_memberships
  has_many :titles,:through => :title_category_memberships


  has_many :category_title_list_memberships
  has_many :title_lists, :through => :category_title_list_memberships
  accepts_nested_attributes_for :category_title_list_memberships, :allow_destroy => true  

  mount_uploader :image, ImageUploader

  def slug
    name.downcase.gsub(/[^a-z0-9]/, "-")  
  end

  def to_param
    "#{id}-#{slug}"
  end


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
