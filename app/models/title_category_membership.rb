class TitleCategoryMembership < ActiveRecord::Base
  belongs_to :title
  belongs_to :category
  # attr_accessible :title, :body
end
