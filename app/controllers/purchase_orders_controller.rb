class PurchaseOrdersController < ApplicationController
  autocomplete :distributor,:name,:full=>true,:display_value=>:name_and_id

  before_filter :authenticate_user! 
  before_filter :hack_out_params , :only=>[:create,:update]
  load_and_authorize_resource 
  helper_method :sort_column, :sort_direction

  
  

  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.includes([:purchase_order_line_items,:distributor]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(40)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_orders }
    end
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order_line_items=@purchase_order.purchase_order_line_items.where("quantity > 0 or cancelled > 0").page(params[:page]).per(40)
    respond_to do |format|
      format.html # show.html.erb
      format.text
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

    @purchase_order.ordered=false




    respond_to do |format|
      if @purchase_order.save
        upload_results=@purchase_order.process_upload
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully created. ' + upload_results }
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
    @purchase_order.destroy unless @purchase_order.ordered?

    respond_to do |format|
      format.html { redirect_to purchase_orders_url }
      format.json { head :no_content }
    end
  end


  def smartdestroy
    @purchase_order = PurchaseOrder.find(params[:id])
    @old_number=@purchase_order.number
    @dest_purchase_order = PurchaseOrder.find(params[:dest_purchase_order])
    
    unless @purchase_order.ordered? || @dest_purchase_order.ordered? || (@purchase_order.id == @dest_purchase_order.id)
      @purchase_order.purchase_order_line_items.each do |poli|
        if poli.customer || poli.notes || poli.title.copies.length==0
          poli.purchase_order=@dest_purchase_order
          poli.save!
        else
          poli.destroy
        end
      end

      @purchase_order.reload.destroy 
      @notice="Purchase Order #{@old_number} was successfully destroyed with savable line items moved to purchase order <a href='#{url_for(@dest_purchase_order)}'>#{@dest_purchase_order}</a>"
      @success=true
    else 
      @notice="Something went wrong."
      @success=false
    end
    respond_to do |format|
      format.html { redirect_to purchase_orders_url,notice: @notice.html_safe }
      format.json { head :no_content }
      format.js { }
    end
  end


  def hidden_actions
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      format.html {  }
      format.js { }
    end
  end



  def cancel 
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.cancel
    respond_to do |format|
      format.html {redirect_to @purchase_order}
    end
  end

  def submit 
    @purchase_order = PurchaseOrder.find(params[:id])
    
    @purchase_order.ordered=true
    @purchase_order.ordered_when=DateTime.now
    # @purchase_order.order_by_when=nil

    @purchase_order.save!

    respond_to do |format|
      format.html {redirect_to @purchase_order}
    end
  end

  def receive
    @purchase_order = PurchaseOrder.find(params[:id])
    
    raise "You can't recieve a non-ordered order" unless @purchase_order.ordered?
    
    @invoice=Invoice.new
    @invoice.distributor=@purchase_order.distributor
    @invoice.number="#{DateTime.now.year}-#{DateTime.now.month}-#{DateTime.now.day}-#{@purchase_order.id}"
    @invoice.shipping_cost=0
    
    @invoice.owner=@purchase_order.owner || Owner.default_owner

    @invoice.save!

    @purchase_order.purchase_order_line_items.each do |po_li| 
      if po_li.quantity > 0 && (po_li.quantity - po_li.received) > 0 
        i_li=InvoiceLineItem.new
        i_li.quantity= po_li.quantity - po_li.received
        i_li.edition=po_li.edition
        i_li.purchase_order_line_item=po_li
        i_li.discount=40
        i_li.price = i_li.edition.list_price 
        @invoice.invoice_line_items << i_li
      end
    end



    respond_to do |format|
      format.html {redirect_to @invoice}
    end
  end



  private

  def hack_out_params
    params[:purchase_order].delete :distributor
    params[:purchase_order].delete :owner
  end


  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
    %w[created_at number distributors.name ordered ordered_when order_by_when].include?(params[:sort]) ? params[:sort] : "created_at"
  end

end
