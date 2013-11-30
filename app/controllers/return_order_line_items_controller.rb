class ReturnOrderLineItemsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource
  

  # GET /return_order_line_items
  # GET /return_order_line_items.json
  def index
    @return_order_line_items = ReturnOrderLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @return_order_line_items }
    end
  end

  # GET /return_order_line_items/1
  # GET /return_order_line_items/1.json
  def show
    @return_order_line_item = ReturnOrderLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @return_order_line_item }
    end
  end

  # GET /return_order_line_items/new
  # GET /return_order_line_items/new.json
  def new
    @return_order_line_item = ReturnOrderLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @return_order_line_item }
    end
  end

  # GET /return_order_line_items/1/edit
  def edit
    @return_order_line_item = ReturnOrderLineItem.find(params[:id])
  end

  # POST /return_order_line_items
  # POST /return_order_line_items.json
  def create
    @return_order_line_item = ReturnOrderLineItem.new(params[:return_order_line_item])

    respond_to do |format|
      if @return_order_line_item.save
        format.html { redirect_to @return_order_line_item, notice: 'Return order line item was successfully created.' }
        format.json { render json: @return_order_line_item, status: :created, location: @return_order_line_item }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @return_order_line_item.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /return_order_line_items/1
  # PUT /return_order_line_items/1.json
  def update
    @return_order_line_item = ReturnOrderLineItem.find(params[:id])

    respond_to do |format|
      if @return_order_line_item.update_attributes(params[:return_order_line_item])
        format.html { redirect_to @return_order_line_item, notice: 'Return order line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @return_order_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_order_line_items/1
  # DELETE /return_order_line_items/1.json
  def destroy
    @return_order_line_item = ReturnOrderLineItem.find(params[:id])
    
    
    
    
    
    respond_to do |format|
      if @return_order_line_item.return_order.posted? 
        format.js {}
      else
        @id=@return_order_line_item.id
        @return_order_line_item.destroy
        format.html { redirect_to return_order_line_items_url }
        format.json { head :no_content }
        format.js {}
      end
      end
  end
end
