class PurchaseOrdersController < ApplicationController
  autocomplete :distributor,:name,:full=>true,:display_value=>:name_and_id

  before_filter :authenticate_user! 
  before_filter :hack_out_params , :only=>[:create,:update]
  load_and_authorize_resource 
  

  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_orders }
    end
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase_order }
    end
  end

  # GET /purchase_orders/new
  # GET /purchase_orders/new.json
  def new
    @purchase_order = PurchaseOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase_order }
    end
  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(params[:purchase_order])

    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully created.' }
        format.json { render json: @purchase_order, status: :created, location: @purchase_order }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_orders/1
  # PUT /purchase_orders/1.json
  def update
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      if @purchase_order.update_attributes(params[:purchase_order])
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.destroy

    respond_to do |format|
      format.html { redirect_to purchase_orders_url }
      format.json { head :no_content }
    end
  end

  def submit 
    @purchase_order = PurchaseOrder.find(params[:id])
    
    @purchase_order.ordered=true
    @purchase_order.ordered_when=DateTime.now

    @purchase_order.save!

    respond_to do |format|
      format.html {redirect_to @purchase_order}
    end
  end


  private

  def hack_out_params
    params[:purchase_order].delete :distributor
  end


end
