class ShoppingCartsController < ApplicationController 
  before_filter :authenticate_user!, :except=>[:current,:update_current,:checkout]
  protect_from_forgery :except => [:checkout]


  load_and_authorize_resource

  # GET /shopping_carts
  # GET /shopping_carts.json
  def index
    @shopping_carts = ShoppingCart.where(:submitted=>true).order("submitted_when desc").page(params[:page]).per(200)
    @cart_search=CartSearch.new(params[:cart_search])

    @shopping_carts = @shopping_carts.where(:completed=>[false,nil]) unless @cart_search.show_completed
    @shopping_carts = @shopping_carts.where(:is_preorder=>true) if @cart_search.only_preorders
    @shopping_carts = @shopping_carts.where(:shipping_method=>"Pickup") if @cart_search.only_preorders
    @shopping_carts = @shopping_carts.where(:pulled=>true) if @cart_search.pulled
    @shopping_carts = @shopping_carts.where(:pulled=>[false,nil]) if @cart_search.unpulled
    @shopping_carts = @shopping_carts.where("shipping_email LIKE ?", "%" + @cart_search.email + "%" ) unless @cart_search.email.blank?

    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shopping_carts }
    end
  end

  # GET /shopping_carts/1
  # GET /shopping_carts/1.json
  def show
    @shopping_cart = ShoppingCart.find(params[:id])
    EasyPost.api_key= ENV["EASYPOST_API_KEY"]
    @shipment = EasyPost::Shipment.retrieve(@shopping_cart.easypost_shipment_id) unless @shopping_cart.easypost_shipment_id.nil?

    
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

  def garbagecollect
    x=0
    ShoppingCart.where(:submitted => nil).where(:created_at => 10000.days.ago.to_date..6.days.ago.to_date).limit(10000).each do |c| 
      if c.empty?
        c.destroy
        x=x+1
      end
    end

    respond_to do |format|
      format.html { redirect_to shopping_carts_url,notice: "Deleted #{x} unused carts." } 
      format.json { head :no_content }
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
    @shopping_cart.shipping_notes=params[:shopping_cart][:shipping_notes]
    @shopping_cart.shipping_address_type=params[:shopping_cart][:shipping_address_type] 
    @shopping_cart.shipping_subscribe=params[:shopping_cart][:shipping_subscribe]


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
        @shopping_cart.shipping_stripe_id=charge.id
        @shopping_cart.save!
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


  def checkout
    @shopping_cart=current_cart
    stripe_session = Stripe::Checkout::Session.create({
                                                        payment_method_types: ['card'],
                                                        line_items:
                                                          shopping_cart_line_items.collect do |x|   
                                                          {
                                                            price_data: {
                                                              currency: 'usd',
                                                              product_data: {
                                                                name: 'T-shirt',
                                                              },
                                                              unit_amount: x.cost,
                                                            },
                                                            quantity: x.quantity,
                                                          }
                                                        end,
                                                      mode: 'payment',
                                                      success_url: 'https://example.com/success',
                                                      cancel_url: 'https://example.com/cancel',
                                                     })
    render json: stripe_session 
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
    @shopping_cart.completed_when=DateTime.now
    if @shopping_cart.save
      respond_to do |format|
        format.html {redirect_to @shopping_cart, notice: 'Shopping cart is marked as complete!  Make sure you really deal with this!!!!' }
        format.js {}
      end
    else
      raise "couldn't save cart"
    end
  end

  def toggle_pulled
    toggle_state(ShoppingCart.find(params[:id]),:pulled)
  end

 def toggle_sold_through
    toggle_state(ShoppingCart.find(params[:id]),:sold_through)
  end

 def toggle_shipped
    toggle_state(ShoppingCart.find(params[:id]),:shipped)
  end

 def toggle_picked_up
    toggle_state(ShoppingCart.find(params[:id]),:picked_up)
  end

 def toggle_pickup_notify
    toggle_state(ShoppingCart.find(params[:id]),:pickup_notify)
  end

 
 def toggle_is_preorder
    toggle_state(ShoppingCart.find(params[:id]),:is_preorder)
  end



  def toggle_state(cart,state)
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.toggle(state)
    if @shopping_cart.save
      respond_to do |format|
        format.html {redirect_to @shopping_cart}
        format.js {}
      end
    else
      raise "couldn't save cart"
    end
  end

  def ship
    @shopping_cart = ShoppingCart.find(params[:id])
    rate=params[:rate]
    if (! @shopping_cart.weight.nil? ) && (rate == "MediaMail" || rate == "Priority")
      EasyPost.api_key= ENV["EASYPOST_API_KEY"]
      parcel = EasyPost::Parcel.create(
        :weight => @shopping_cart.weight,
        :height => 4,
        :length => 14,
        :width => 10
      )

      from_address = EasyPost::Address.create(
        street1: "1225 CATHEDRAL ST.",
        street2: "",
        city: "BALTIMORE",
        state: "MD",
        zip: "21201",
        country: "US",
        company: "Red Emma's Cooperative Corporation",
        phone: "(410) 601-3072"
      )

      to_address = EasyPost::Address.create(
        name: @shopping_cart.shipping_name,
        street1: @shopping_cart.shipping_address_1,
        street2: @shopping_cart.shipping_address_2,
        city: @shopping_cart.shipping_city,
        state: @shopping_cart.shipping_state,
        zip: @shopping_cart.shipping_zip 
      )

        
      shipment = EasyPost::Shipment.create(
        :to_address => to_address,
        :from_address => from_address,
        :parcel => parcel,
        :options => {"special_rates_eligibility": "USPS.MEDIAMAIL"})
      
      s=shipment.rates.find_all {|x| x.service==rate}.first
      shipment.buy(:rate=>s) unless s.nil?
      
      @shopping_cart.easypost_shipment_id=shipment.id
      
      if (! s.nil?) && @shopping_cart.save 
        respond_to do |format|
          format.html {redirect_to @shopping_cart, notice: 'Shopping cart is shippable using links to postage and tracker below' }
        end
      else
       respond_to do |format|
         format.html {redirect_to @shopping_cart, notice: 'Shopping cart is not shippable. Check addresses?' }
        end
      end
    else
       respond_to do |format|
         format.html {redirect_to @shopping_cart, notice: 'Shopping cart is not shippable. Check weight?' }
        end
       
    end
    
  end

  
    def defer
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.deferred=true
    if @shopping_cart.save
      respond_to do |format|
        format.html {redirect_to @shopping_cart, notice: 'Shopping cart is marked as deferred!  Do not forget about this one!!!!' }
        format.js {}
      end
    else
      raise "couldn't save cart"
    end
  end

  def subscribe
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.shipping_subscribed=true
    if @shopping_cart.save
      respond_to do |format|
        format.html {redirect_to @shopping_cart, notice: 'Shopping cart is marked as subscribed!' }
        format.js {}
      end
    else
      raise "couldn't save cart"
    end
  end


end
