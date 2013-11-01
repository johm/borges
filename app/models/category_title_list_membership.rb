class CategoryTitleListMembership < ActiveRecord::Base

  belongs_to :title_list
  belongs_to :category
  attr_accessible :position,:title_list_id,:category_id
end
