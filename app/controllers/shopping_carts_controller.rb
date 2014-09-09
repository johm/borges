class ShoppingCartsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:current,:update_current]
  load_and_authorize_resource

  # GET /shopping_carts
  # GET /shopping_carts.json
  def index
    @shopping_carts = ShoppingCart.where(:submitted=>true).order("submitted_when desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shopping_carts }
    end
  end

  # GET /shopping_carts/1
  # GET /shopping_carts/1.json
  def show
    @shopping_cart = ShoppingCart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shopping_cart }
    end
  end

  # GET /shopping_carts/new
  # GET /shopping_carts/new.json
  def new
    @shopping_cart = ShoppingCart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shopping_cart }
    end
  end

  # GET /shopping_carts/1/edit
  def edit
    @shopping_cart = ShoppingCart.find(params[:id])
  end

  # POST /shopping_carts
  # POST /shopping_carts.json
  def create
    @shopping_cart = ShoppingCart.new(params[:shopping_cart])

    respond_to do |format|
      if @shopping_cart.save
        format.html { redirect_to @shopping_cart, notice: 'Shopping cart was successfully created.' }
        format.json { render json: @shopping_cart, status: :created, location: @shopping_cart }
      else
        format.html { render action: "new" }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shopping_carts/1
  # PUT /shopping_carts/1.json
  def update
    @shopping_cart = ShoppingCart.find(params[:id])
    respond_to do |format|
      if @shopping_cart.update_attributes(params[:shopping_cart])
        format.html { redirect_to @shopping_cart, notice: 'Shopping cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shopping_carts/1
  # PUT /shopping_carts/1.json
  def update_current
    # this only gets called when stripe goes through
    #  raise "no stripe no action" unless 

    @shopping_cart=current_cart
    
    # and we don't do anything if we have already ordered
    raise "can't change ordered cart" if @shopping_cart.submitted?  

    @shopping_cart.shipping_method=params[:shopping_cart][:shipping_method]
    @shopping_cart.shipping_address_1=params[:shopping_cart][:shipping_address_1] 
    @shopping_cart.shipping_address_2=params[:shopping_cart][:shipping_address_2] 
    @shopping_cart.shipping_city=params[:shopping_cart][:shipping_city] 
    @shopping_cart.shipping_name=params[:shopping_cart][:shipping_name] 
    @shopping_cart.shipping_state=params[:shopping_cart][:shipping_state] 
    @shopping_cart.shipping_zip=params[:shopping_cart][:shipping_zip] 
    @shopping_cart.shipping_email=params[:stripe_email]
    @shopping_cart.save!

    #do the stripe stuff
    if params[:stripe_token]
      begin
        customer = Stripe::Customer.create(
                                           :email => @shopping_cart.shipping_email,
                                           :card  => params[:stripe_token]
                                           )
        
        charge = Stripe::Charge.create(
                                       :customer    => customer.id,
                                       :amount      => @shopping_cart.total.cents,
                                       :description => "Red Emma's Bookstore Coffeehouse Order # #{@shopping_cart.id}",
                                       :currency    => 'usd'
                                       )
        
      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to "/cart"
      end
      
    # record payment
      @shopping_cart.submit_order
      new_shopping_cart = ShoppingCart.new(:shipping_method=>"Pickup",:shipping_subscribe=>true)
      new_shopping_cart.save!
      session[:shopping_cart_id] = new_shopping_cart.id
    end
    respond_to do |format|
      format.js {}
    end
  end
  

  # DELETE /shopping_carts/1
  # DELETE /shopping_carts/1.json
  def destroy
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.destroy

    respond_to do |format|
      format.html { redirect_to shopping_carts_url }
      format.json { head :no_content }
    end
  end

  def current
    @oncart=true
    @shopping_cart=current_cart 
    if @shopping_cart.submitted? 
      #you get a new cart
      @shopping_cart=new_cart
    end
    warn "CART ID #{@shopping_cart.id}"
    raise "errr..." if @shopping_cart.nil?
  end

  def complete
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.completed=true
    if @shopping_cart.save
      respond_to do |format|
        format.js {}
      end
    else
      raise "couldn't save cart"
    end
  end

  def defer
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.deferred=true
    if @shopping_cart.save
      respond_to do |format|
        format.js {}
      end
    else
      raise "couldn't save cart"
    end
  end

end
