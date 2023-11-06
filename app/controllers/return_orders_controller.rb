class ReturnOrdersController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :hack_out_params , :only=>[:create,:update]  
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction


  # GET /return_orders
  # GET /return_orders.json
  def index
    @return_orders = ReturnOrder.includes([:return_order_line_items,:copies,:distributor]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(40)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @return_orders }
    end
  end

  # GET /return_orders/1
  # GET /return_orders/1.json
  def show
    @return_order = ReturnOrder.find(params[:id])
    

    respond_to do |format|
      format.html # show.html.erb
      format.text
      format.json { render json: @return_order }
    end
  end

  # GET /return_orders/new
  # GET /return_orders/new.json
  def new
    @return_order = ReturnOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @return_order }
    end
  end

  # GET /return_orders/1/edit
  def edit
    @return_order = ReturnOrder.find(params[:id])
  end

  # POST /return_orders
  # POST /return_orders.json
  def create
    @return_order = ReturnOrder.new(params[:return_order])
    @return_order.posted=false


    respond_to do |format|
      if @return_order.save
        format.html { redirect_to @return_order, notice: 'Return order was successfully created.' }
        format.json { render json: @return_order, status: :created, location: @return_order }
      else
        format.html { render action: "new" }
        format.json { render json: @return_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /return_orders/1
  # PUT /return_orders/1.json
  def update
    @return_order = ReturnOrder.find(params[:id])

    respond_to do |format|
      if @return_order.update_attributes(params[:return_order])
        format.html { redirect_to @return_order, notice: 'Return order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @return_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_orders/1
  # DELETE /return_orders/1.json
  def destroy
    @return_order = ReturnOrder.find(params[:id])
    @return_order.destroy

    respond_to do |format|
      format.html { redirect_to return_orders_url }
      format.json { head :no_content }
    end
  end

  
  def post
    unless @return_order.posted? 
      @return_order = ReturnOrder.find(params[:id])
      @return_order.return_order_line_items.each do |roli|
        roli.do_return
      end
      @return_order.posted=true
      @return_order.posted_when=DateTime.now
      @return_order.save!
    end
    respond_to do |format|
      format.html { redirect_to @return_order, notice: 'Return was successfully posted!' }
    end
  end


  private
  def hack_out_params
    params[:return_order].delete :distributor
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
    %w[created_at distributors.name posted_when].include?(params[:sort]) ? params[:sort] : "created_at"
  end



end
