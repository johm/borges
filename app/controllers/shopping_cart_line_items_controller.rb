class ShoppingCartLineItemsController < ApplicationController
  before_filter :authenticate_user!,:except=>[:update,:destroy]

  # GET /shopping_cart_line_items
  # GET /shopping_cart_line_items.json
  def index
    @shopping_cart_line_items = ShoppingCartLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shopping_cart_line_items }
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

    respond_to do |format|
      if @shopping_cart_line_item.update_attributes(params[:shopping_cart_line_item])
        format.html { redirect_to @shopping_cart_line_item, notice: 'Shopping cart line item was successfully updated.' }
        format.json { render json: {
            new_ext: (@shopping_cart_line_item.cost * @shopping_cart_line_item.quantity).to_s,
            new_total: @shopping_cart_line_item.shopping_cart.total.to_s
          } 
        }
        
      else
        format.html { render action: "edit" }
        format.json { render json: @shopping_cart_line_item.errors, status: :unprocessable_entity }
      end
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
