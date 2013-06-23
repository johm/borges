class PostTitleLink < ActiveRecord::Base
  belongs_to :post
  belongs_to :title
  attr_accessible :title_id,:post_id
end
