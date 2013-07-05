class Post < ActiveRecord::Base
  has_many :images, :as => :imagey
  belongs_to :post_category
  has_many :post_title_links
  has_many :titles, :through => :post_title_links 
  has_many :post_title_list_links
  has_many :title_lists, :through => :post_title_list_links 
  
  attr_accessible :body, :introduction, :slug, :title, :post_category_id, :images_attributes, :post_title_links_attributes, :post_title_list_links_attributes
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :post_title_links, :allow_destroy => true
  accepts_nested_attributes_for :post_title_list_links, :allow_destroy => true

  extend FriendlyId
  friendly_id :dated_slug, use: :slugged

  def dated_slug
    "#{DateTime.now.strftime('%Y-%m')}-#{title}"
  end
  
  def title_and_slug
    "#{title}"
  end

end
