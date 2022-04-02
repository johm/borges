class Contribution < ActiveRecord::Base
  attr_accessible :author_id, :title_id, :what, :author
  belongs_to :author
  belongs_to :title

  after_save :delete_gatsby_cache

  def delete_gatsby_cache
    Rails.cache.delete("gatsby-graphql")
  end

  
  def to_s
    if author 
      if ! what.blank? 
        "#{author.full_name} (#{what})"
      else
        author.full_name
      end
    else
      ""
    end  
  end

end
