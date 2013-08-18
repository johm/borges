class PurchaseOrderLineItemsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource 

  

  # GET /purchase_order_line_items
  # GET /purchase_order_line_items.json
  def index
    @purchase_order_line_items = PurchaseOrderLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_order_line_items }
    end
  end

  # GET /purchase_order_line_items/1
  # GET /purchase_order_line_items/1.json
  def show
    @purchase_order_line_item = PurchaseOrderLineItem.find(params[:id])

    respond_to do |format|
      format.html {render partial: "/purchase_order_line_items/purchase_order_line_item", object: @purchase_order_line_item } # show.html.erb
      format.json { render json: @purchase_order_line_item }
    end
  end

  # GET /purchase_order_line_items/new
  # GET /purchase_order_line_items/new.json
  def new
    @purchase_order_line_item = PurchaseOrderLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase_order_line_item }
      format.js 
    end
  end

  # GET /purchase_order_line_items/1/edit
  def edit
    @purchase_order_line_item = PurchaseOrderLineItem.find(params[:id])
  end

  # POST /purchase_order_line_items
  # POST /purchase_order_line_items.json
  def create
    @purchase_order_line_item = PurchaseOrderLineItem.new(params[:purchase_order_line_item])
    @purchase_order_line_item.quantity=1 if @purchase_order_line_item.quantity.nil?
    respond_to do |format|
      if @purchase_order_line_item.save
        format.html { redirect_to @purchase_order_line_item, notice: 'Purchase order line item was successfully created.' }
        format.json { render json: @purchase_order_line_item, status: :created, location: @purchase_order_line_item }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @purchase_order_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_order_line_items/1
  # PUT /purchase_order_line_items/1.json
  def update
    @purchase_order_line_item = PurchaseOrderLineItem.find(params[:id])

    respond_to do |format|
      if @purchase_order_line_item.update_attributes(params[:purchase_order_line_item])
        format.html { redirect_to @purchase_order_line_item, notice: 'Purchase order line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase_order_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_order_line_items/1
  # DELETE /purchase_order_line_items/1.json
  def destroy
    @purchase_order_line_item = PurchaseOrderLineItem.find(params[:id])
    @purchase_order_line_item.destroy

    respond_to do |format|
      format.html { redirect_to purchase_order_line_items_url }
      format.json { head :no_content }
    end
  end
end
