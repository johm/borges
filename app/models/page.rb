class Page < ActiveRecord::Base
  belongs_to :parent, :class_name => "Page"
  has_many :children,:class_name => "Page", :foreign_key => "parent_id"
  has_many :images, :as => :imagey
  validates :layout,:presence => true
  validates :layout,:inclusion => {:in => PagesController.helpers.layouts}
  
  attr_accessible :body, :introduction, :slug, :title, :parent_id, :images_attributes,:is_hero,:layout,:published,:is_image_grid
  accepts_nested_attributes_for :images, :allow_destroy => true

  extend FriendlyId
  friendly_id :title, use: :slugged

  def title_and_slug
    "#{title}"
  end

  def to_s
    "#{title}"
  end

  def ancestor
    if parent.nil? 
      self
    else
      parent.ancestor
    end
  end

end
