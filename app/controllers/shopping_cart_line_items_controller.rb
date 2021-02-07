class ShoppingCartLineItemsController < ApplicationController
  before_filter :authenticate_user!,:except=>[:create,:update,:destroy]

  # GET /shopping_cart_line_items
  # GET /shopping_cart_line_items.json
  def index
    @shopping_cart_line_items = ShoppingCartLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shopping_cart_line_items }
    end
  end

  def split
    @shopping_cart_line_item = ShoppingCartLineItem.find(params[:id])
    @old_cart=@shopping_cart_line_item.shopping_cart
    @new_cart=@old_cart.dup

    @new_cart.notes="This order was split from order #{@old_cart.id}"

    @new_cart.easypost_shipment_id=nil;
    
    @new_cart.save!
    @old_cart.notes=@old_cart.notes+" This order has an item split onto order #{@new_cart.id}"
    @old_cart.save!

    @shopping_cart_line_item.shopping_cart = @new_cart
    @shopping_cart_line_item.save!
    respond_to do |format|
      format.html { redirect_to @new_cart, notice: 'Successfully created a split cart.' }
    end
  end  

  
  # GET /shopping_cart_line_items/1
  # GET /shopping_cart_line_items/1.json
  def show
    @shopping_cart_line_item = ShoppingCartLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shopping_cart_line_item }
    end
  end

  # GET /shopping_cart_line_items/new
  # GET /shopping_cart_line_items/new.json
  def new
    @shopping_cart_line_item = ShoppingCartLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shopping_cart_line_item }
    end
  end

  # GET /shopping_cart_line_items/1/edit
  def edit
    @shopping_cart_line_item = ShoppingCartLineItem.find(params[:id])
  end

  # POST /shopping_cart_line_items
  # POST /shopping_cart_line_items.json
  def create
    @shopping_cart_line_item = ShoppingCartLineItem.new(params[:shopping_cart_line_item])
    @shopping_cart_line_item.edition=Edition.find(params[:edition])
    @shopping_cart_line_item.quantity=1
    @shopping_cart_line_item.cost=@shopping_cart_line_item.edition.my_online_price
    @shopping_cart_line_item.shopping_cart=current_cart
    @shopping_cart_line_item.save!
    

    respond_to do |format|
      format.html { redirect_to "/cart", notice: 'The item was added to your cart successfully.' }
    end
  end

  # PUT /shopping_cart_line_items/1
  # PUT /shopping_cart_line_items/1.json
  def update
    @shopping_cart_line_item = ShoppingCartLineItem.find(params[:id])

    unless can? :edit,ShoppingCartLineItem
      raise "hell" unless @shopping_cart_line_item.shopping_cart.id==current_cart.id #only edit things in your session's cart!
      params[:shopping_cart_line_item]=params[:shopping_cart_line_item].keep_if {|k,v| k==:quantity} #only change the quantity!
    end

    raise "can't change quantities for ordered cart" if @shopping_cart_line_item.shopping_cart.ordered?

    wanted=params[:shopping_cart_line_item][:quantity].to_i
    instock=@shopping_cart_line_item.edition.copies.where("status"=>"STOCK").length
    
    if wanted > instock
      @shopping_cart_line_item.quantity=instock
      flash[:notice]="We only have #{instock} of this edition available at the moment."
    else
      @shopping_cart_line_item.quantity=wanted
    end

    @shopping_cart_line_item.save!
    respond_to do |format|
        format.html { redirect_to @shopping_cart_line_item, notice: 'Shopping cart line item was successfully updated.' }
        format.json { render json: {
          new_ext: (@shopping_cart_line_item.cost * @shopping_cart_line_item.quantity).to_s,
          new_subtotal: @shopping_cart_line_item.shopping_cart.subtotal.to_s,
          new_tax: @shopping_cart_line_item.shopping_cart.tax.to_s,
          new_total: @shopping_cart_line_item.shopping_cart.total.to_s,
          new_shipping_cost: @shopping_cart_line_item.shopping_cart.shipping_cost.to_s,
          new_quantity: @shopping_cart_line_item.quantity
          } 
        }
    end
  end

  # DELETE /shopping_cart_line_items/1
  # DELETE /shopping_cart_line_items/1.json
  def destroy
    @shopping_cart_line_item = ShoppingCartLineItem.find(params[:id])
    @shopping_cart= @shopping_cart_line_item.shopping_cart

    unless can? :edit,ShoppingCartLineItem
      raise "hell" unless @shopping_cart_line_item.shopping_cart.id==current_cart.id #only destroy things in your session's cart!
    end

    raise "can't change quantities for ordered cart" if @shopping_cart_line_item.shopping_cart.ordered?

    @shopping_cart_line_item.destroy

    respond_to do |format|
      format.html { redirect_to "/cart" }
      format.json { head :no_content }
    end
  end
end
