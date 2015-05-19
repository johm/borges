class InvoicesController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :hack_out_params , :only=>[:create,:update]

  load_and_authorize_resource
  helper_method :sort_column, :sort_direction

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.includes([:invoice_line_items,:distributor]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  def receive
    @invoice = Invoice.find(params[:id])

    @invoice.receive
    
    respond_to do |format|
      format.html { redirect_to @invoice }
      format.json { head :no_content }
    end
  end

  def chart 
    
    big_distributors=Distributor.all.find_all {|d| d.purchase_orders.where(:ordered=>true).length >= 2}
    
    @distributors_to_invoices={}
    
    big_distributors.each do |distributor|
      
      invoices=[]
      
      distributor.invoices.where(:received=>true).each do |i| 
        total=i.total_cost+i.shipping_cost 
        sales_to_date=i.sales_to_date 
        returns_to_date=i.returns_to_date
        invoice_net=sales_to_date-(total-returns_to_date)
        invoices.append([i.received_when.to_time.to_i*1000 ,invoice_net.to_f])
      end
      
      @distributors_to_invoices[distributor]=invoices
    end
    respond_to do |format|
      format.html { render action: "chart" }
    end
  end
  
  private

  def hack_out_params
    params[:invoice].delete :distributor
    params[:invoice].delete :owner
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
    %w[created_at id number distributors.name received_when].include?(params[:sort]) ? params[:sort] : "created_at"
  end


end
