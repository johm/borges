class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected 
  def current_cart
    begin
      ShoppingCart.find(session[:shopping_cart_id])
    rescue ActiveRecord::RecordNotFound
      shopping_cart = ShoppingCart.create
      session[:shopping_cart_id] = shopping_cart.id
      shopping_cart
    end
  end

  
end
