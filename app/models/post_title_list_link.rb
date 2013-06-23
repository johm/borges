class PostTitleListLink < ActiveRecord::Base
  belongs_to :post
  belongs_to :title_list
  attr_accessible :post_id, :title_list_id
end
