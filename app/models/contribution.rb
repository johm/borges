class Contribution < ActiveRecord::Base
  attr_accessible :author_id, :title_id, :what
  belongs_to :author
  belongs_to :title

  def to_s
    if author 
      if what 
        "#{author.full_name} (#{what})"
      else
        author.full_name
      end
    else
      ""
    end  
  end

end
