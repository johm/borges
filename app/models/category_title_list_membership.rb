class CategoryTitleListMembership < ActiveRecord::Base
  belongs_to :title_list_id
  belongs_to :category_id
  attr_accessible :index,:title_list_id,:category_id
end
