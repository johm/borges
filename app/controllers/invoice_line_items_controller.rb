class InvoiceLineItemsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource

  # GET /invoice_line_items
  # GET /invoice_line_items.json
  def index
    @invoice_line_items = InvoiceLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice_line_items }

    end
  end

  # GET /invoice_line_items/1
  # GET /invoice_line_items/1.json
  def show
    @invoice_line_item = InvoiceLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice_line_item }
    end
  end

  # GET /invoice_line_items/new
  # GET /invoice_line_items/new.json
  def new
    @invoice_line_item = InvoiceLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice_line_item }
    end
  end

  # GET /invoice_line_items/1/edit
  def edit
    @invoice_line_item = InvoiceLineItem.find(params[:id])
  end

  # POST /invoice_line_items
  # POST /invoice_line_items.json
  def create
    @invoice_line_item = InvoiceLineItem.new(params[:invoice_line_item])
    
    begin
      @invoice_line_item.discount=@invoice_line_item.invoice.invoice_line_items.last().discount
    rescue
    end

    begin
      @invoice_line_item.price = @invoice_line_item.edition.list_price
    rescue
      @invoice_line_item.price = 0
    end

    respond_to do |format|
      if @invoice_line_item.save
        format.html { redirect_to @invoice_line_item, notice: 'Invoice line item was successfully created.' }
        format.json { render json: @invoice_line_item, status: :created, location: @invoice_line_item }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @invoice_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoice_line_items/1
  # PUT /invoice_line_items/1.json
  def update
    @invoice_line_item = InvoiceLineItem.find(params[:id])

    respond_to do |format|
      if @invoice_line_item.update_attributes(params[:invoice_line_item])
        format.html { redirect_to @invoice_line_item.invoice, notice: 'Invoice line item was successfully updated.' }
        format.js {}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoice_line_items/1
  # DELETE /invoice_line_items/1.json
  def destroy
    @invoice_line_item = InvoiceLineItem.find(params[:id])
    @invoice_line_item.destroy

    respond_to do |format|
      format.html { redirect_to invoice_line_items_url }
      format.json { head :no_content }
    end
  end
end
