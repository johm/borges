class BucketLineItemsController < ApplicationController
  before_filter :hack_out_params , :only=>[:create,:update]

  before_filter :authenticate_user!, :except=>[:create_from_webhook] 
  protect_from_forgery :except => [:create_from_webhook]

  load_and_authorize_resource :except => [:create_from_webhook]

  

  # GET /bucket_line_items
  # GET /bucket_line_items.json
  def index
    @bucket_line_items = BucketLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bucket_line_items }
    end
  end

  # GET /bucket_line_items/1
  # GET /bucket_line_items/1.json
  def show
    @bucket_line_item = BucketLineItem.find(params[:id])

    respond_to do |format|
      format.html {render partial: "/bucket_line_items/bucket_line_item", object: @bucket_line_item } # show.html.erb
      format.json { render json: @bucket_line_item }
    end
  end

  # GET /bucket_line_items/new
  # GET /bucket_line_items/new.json
  def new
    @bucket_line_item = BucketLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bucket_line_item }
      format.js 
    end
  end

  # GET /bucket_line_items/1/edit
  def edit
    @bucket_line_item = BucketLineItem.find(params[:id])
  end

  def create_from_webhook 
    bucket=Bucket.where(:name => "#booksthatarecool").first
    @bucket_line_item = BucketLineItem.new(:notes => "#{params[:slackbook]} [from #{params[:slackuser]}]")
    @bucket_line_item.bucket = bucket
    @bucket_line_item.save! 
    head :ok       
  end

  # POST /bucket_line_items
  # POST /bucket_line_items.json
  def create
    @bucket_line_item = BucketLineItem.new(params[:bucket_line_item])
    respond_to do |format|
      if @bucket_line_item.save
        format.html { redirect_to @bucket_line_item, notice: 'Bucket line item was successfully created.' }
        format.json { render json: @bucket_line_item, status: :created, location: @bucket_line_item }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @bucket_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bucket_line_items/1
  # PUT /bucket_line_items/1.json
  def update
    @bucket_line_item = BucketLineItem.find(params[:id])

    respond_to do |format|
      if @bucket_line_item.update_attributes(params[:bucket_line_item])
        format.html { redirect_to @bucket_line_item, notice: 'Bucket line item was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        format.html { render action: "edit" }
        format.json { render json: @bucket_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bucket_line_items/1
  # DELETE /bucket_line_items/1.json
  def destroy
    @bucket_line_item = BucketLineItem.find(params[:id])
    @bucket_line_item.destroy

    respond_to do |format|
      format.html { redirect_to bucket_line_items_url }
      format.json { head :no_content }
      format.js {}
    end
  end




  def hidden_actions
    @bucket_line_item = BucketLineItem.find(params[:id])
    respond_to do |format|
      format.html {  }
      format.js { }
    end
  end
    

  def move_to_bucket
    @move=true
    @old_bucket=@bucket_line_item.bucket
    @bucket_line_item = BucketLineItem.find(params[:id])
    @bucket = Bucket.find(params[:bucket])
    @bucket_line_item.bucket = @bucket 
    @bucket_line_item.save!
    @notice="Item #{@bucket_line_item.edition.title rescue ''} was successfully moved to bucket <a href='#{url_for(@bucket)}'>#{@bucket.name}</a>"
    respond_to do |format| 
      format.html { redirect_to @old_bucket, notice: "Item #{@bucket_line_item.edition.title} was successfully moved to bucket <a href='#{url_for(@bucket)}'>#{@bucket}</a>".html_safe }
      format.js { render :action => "updatemodal"}
    end
  end

  def copy_to_bucket
    @old_bucket=@bucket_line_item.bucket
    @bucket_line_item = BucketLineItem.find(params[:id])
    @bucket = Bucket.find(params[:bucket])
    @new_bucket_line_item=@bucket_line_item.dup
    @new_bucket_line_item.bucket = @bucket 
    @new_bucket_line_item.save!
    @notice="Item #{@bucket_line_item.edition.title rescue ''} was successfully copied to bucket <a href='#{url_for(@bucket)}'>#{@bucket.name}</a>"
    respond_to do |format| 
      format.html { redirect_to @old_bucket, notice: "Item #{@bucket_line_item.edition.title rescue ''} was successfully copied to bucket <a href='#{url_for(@bucket)}'>#{@bucket.name}</a>".html_safe }
      format.js { render :action => "updatemodal"}
    end
  end


  def copy_to_purchase_order
    @old_bucket=@bucket_line_item.bucket
    @bucket_line_item = BucketLineItem.find(params[:id])
    @purchase_order = PurchaseOrder.find(params[:purchase_order])
    @new_purchase_order_line_item=PurchaseOrderLineItem.new(:purchase_order_id => @purchase_order.id,:edition_id=>@bucket_line_item.edition_id,:customer=>@bucket_line_item.customer,:quantity=>1,:notes => "#{@bucket_line_item.notes} From bucket #{@old_bucket.name}")
    @new_purchase_order_line_item.received = 0
    @new_purchase_order_line_item.save!
    @notice= "Item #{@bucket_line_item.edition.title} was successfully copied to purchase order <a href='#{url_for(@purchase_order)}'>#{@purchase_order.number}</a>" 
    respond_to do |format| 
      format.html { redirect_to @old_bucket, notice: "Item #{@bucket_line_item.edition.title} was successfully copied to purchase order <a href='#{url_for(@purchase_order)}'>#{@purchase_order.number}</a>".html_safe }
      format.js { render :action => "updatemodal"}
    end
  end
  

  
  private
  
  def hack_out_params
    params[:bucket_line_item].delete :customer if params[:bucket_line_item]
  end
  
  
end
