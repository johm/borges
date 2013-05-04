class HomeController < ApplicationController
  def index
    @users = User.all
  end
  
  def frontpage
    render :layout => "frontpage"
  end

end
