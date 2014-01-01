class TitleCategoryMembership < ActiveRecord::Base
  belongs_to :title
  belongs_to :category, :touch => true
  attr_accessible :title_id,:category_id
  # attr_accessible :title, :body
end
