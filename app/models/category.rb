class Category < ActiveRecord::Base
  attr_accessible :description, :image, :name
  has_many :titles,:through => :title_category_memberships
end
