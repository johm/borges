class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def about
  end

  def newsletter
  end

  
  def frontpage

    begin
      @instagram = Rails.cache.fetch("instafront",:expires_in => 10.minutes) do
        Instagram.configure do |config|
          config.client_id =     ENV["INSTAGRAM_ID"]
          config.access_token =  ENV["INSTAGRAM_SECRET"]
        end    
      
        client = Instagram.client()
        user = client.user
        
        html = "<div class='row frontstagram row-no-padding'>"
        i=0
        for media_item in client.user_recent_media()
          break if i>3
          i=i+1
          html << "<div class='col-md-3 col-xs-3'><a target='_blank' title='#{media_item.caption.text.gsub(/'/,'&quot;') unless media_item.caption.nil?}' href='#{media_item.link}'><img width='100%' src='#{media_item.images.standard_resolution.url.gsub(/^http:/,"")}'></a></div>"
        end
        html << "</div>"
        html
      end
    rescue
      @instagram=""
    end
    render :layout => "frontpage"
  end

  def interior
    render :layout => "frontpage"
  end

  def thread
    @coffees=Edition.where(:format => "Coffee")
  end

  def food
    begin
      @instagram = Rails.cache.fetch("instafood",:expires_in => 10.minutes) do
        Instagram.configure do |config|
          config.client_id =     ENV["INSTAGRAM_ID"]
          config.access_token =  ENV["INSTAGRAM_SECRET"]
        end    
        
        client = Instagram.client()
        user = client.user
        
    html = "<h1>Recently delicious</h1><ul class='thumbnails'>"
        i=0
        for media_item in client.user_recent_media()
          break if i>8
          i=i+1
          tags = media_item.tags
          if tags.include?("food") || tags.include?("vegan")  || tags.include?("cafe") 
            html << "<li class='span2'><div class='thumbnail'><div style='margin-bottom:10px;'><a target='_blank' href='#{media_item.link}'><img width='100%' src='#{media_item.images.low_resolution.url.gsub(/^http:/,"")}'></div>#{media_item.caption.text}</a></div></li>"
          end
        end
        html << "</ul>"
        html
      end
    rescue
      @instagram=""
    end
    
  end
  
end
