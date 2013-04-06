class Contribution < ActiveRecord::Base
  attr_accessible :author_id, :title_id, :what
  
  belongs_to :author
  belongs_to :title

end
