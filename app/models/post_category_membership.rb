class PostCategoryMembership < ActiveRecord::Base
  belongs_to :post
  belongs_to :post_category
  attr_accessible :post_id,:post_category_id
end
