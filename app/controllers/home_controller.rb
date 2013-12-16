class HomeController < ApplicationController
  def index
    @users = User.all
  end
  
  def frontpage
    render :layout => "frontpage"
  end

  def interior
    render :layout => "frontpage"
  end

  def food
    Instagram.configure do |config|
      config.client_id =     ENV["INSTAGRAM_ID"]
      config.access_token =  ENV["INSTAGRAM_SECRET"]
    end    

    client = Instagram.client()
    user = client.user
    
    html = "<h1>Recently delicious</h1><ul class='thumbnails'>"
    for media_item in client.user_recent_media
      tags = media_item.tags
      if tags.include?("food") || tags.include?("vegan")  || tags.include?("cafe") 
        html << "<li class='span2'><div class='thumbnail'><div style='margin-bottom:10px;'><a target='_blank' href='#{media_item.link}'><img width='100%' src='#{media_item.images.low_resolution.url}'></div>#{media_item.caption.text}</a></div></li>"
      end
    end
    html << "</ul>"
    @instagram=html

  end

end
