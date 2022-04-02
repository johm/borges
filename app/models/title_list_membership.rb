class TitleListMembership < ActiveRecord::Base
  belongs_to :title
  belongs_to :title_list, :touch => true
  attr_accessible :notes,:title_id,:title_list_id,:title

  after_save :delete_gatsby_cache

  def delete_gatsby_cache
    Rails.cache.delete("gatsby-graphql")
  end


end
