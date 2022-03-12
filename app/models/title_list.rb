class TitleList < ActiveRecord::Base
  attr_accessible :description, :name, :public, :title_list_memberships_attributes
  has_many :title_list_memberships
  has_many :titles, :through => :title_list_memberships
  
  has_many :category_title_list_memberships
  has_many :categories, :through => :category_title_list_memberships

  accepts_nested_attributes_for :title_list_memberships, :allow_destroy => true  

  def to_param
    "#{id}-#{slug}"
  end


  
  def to_s
    name_and_id
  end

  def slug
    name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/-$/,"")  
  end

  
  def name_and_id
    "#{name} (#{id})"
  end

  def titles_in_stock
    titles.find_all {|t| t.in_stock > 0 }.length
  end
  
  def total_titles
    titles.length
  end

end
