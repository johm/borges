class SaleOrderLineItemsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource
  

  # GET /sale_order_line_items
  # GET /sale_order_line_items.json
  def index
    @sale_order_line_items = SaleOrderLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sale_order_line_items }
    end
  end

  # GET /sale_order_line_items/1
  # GET /sale_order_line_items/1.json
  def show
    @sale_order_line_item = SaleOrderLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sale_order_line_item }
    end
  end

  # GET /sale_order_line_items/new
  # GET /sale_order_line_items/new.json
  def new
    @sale_order_line_item = SaleOrderLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sale_order_line_item }
    end
  end

  # GET /sale_order_line_items/1/edit
  def edit
    @sale_order_line_item = SaleOrderLineItem.find(params[:id])
  end

  # POST /sale_order_line_items
  # POST /sale_order_line_items.json
  def create
    @sale_order_line_item = SaleOrderLineItem.new(params[:sale_order_line_item])
    @sale_order_line_item.sale_price=@sale_order_line_item.copy.price 
    
    sale_order=SaleOrder.find(params[:sale_order_line_item][:sale_order_id])
    
    if sale_order.sale_order_line_items.collect {|li| li.copy.id }.include? @sale_order_line_item.copy.id
      raise "Can't add same copy to order twice!"
    end

    respond_to do |format|
      if @sale_order_line_item.save
        format.html { redirect_to @sale_order_line_item, notice: 'Sale order line item was successfully created.' }
        format.json { render json: @sale_order_line_item, status: :created, location: @sale_order_line_item }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @sale_order_line_item.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /sale_order_line_items/1
  # PUT /sale_order_line_items/1.json
  def update
    @sale_order_line_item = SaleOrderLineItem.find(params[:id])

    respond_to do |format|
      if @sale_order_line_item.update_attributes(params[:sale_order_line_item])
        format.html { redirect_to @sale_order_line_item, notice: 'Sale order line item was successfully updated.' }
        format.json { render json: {
            new_meta: render_to_string("sale_orders/_meta.html.erb",:locals=>{:sale_order=>@sale_order_line_item.sale_order} )}}
      else
        format.html { render action: "edit" }
        format.json { render json: @sale_order_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_order_line_items/1
  # DELETE /sale_order_line_items/1.json
  def destroy
    @sale_order_line_item = SaleOrderLineItem.find(params[:id])
    @sale_order = @sale_order_line_item.sale_order 

    respond_to do |format|
      if @sale_order.posted? 
        format.js {}
      else
        @id=@sale_order_line_item.id
        @sale_order_line_item.destroy
        @sale_order.reload
        format.html { redirect_to sale_order_line_items_url }
        format.json { head :no_content }
        format.js {}
      end
      end
  end
end
