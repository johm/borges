class PostCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :post_category_memberships
  has_many :posts,:through => :post_category_memberships

end
