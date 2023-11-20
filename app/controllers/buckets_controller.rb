class BucketsController < ApplicationController

  before_filter :authenticate_user! 
  before_filter :hack_out_params , :only=>[:create,:update]
  load_and_authorize_resource 
  helper_method :sort_column, :sort_direction

  
  

  # GET /buckets
  # GET /buckets.json
  def index
    @buckets = Bucket.includes([:bucket_line_items]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(40)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buckets }
    end
  end

  # GET /buckets/1
  # GET /buckets/1.json
  def show
    @bucket = Bucket.find(params[:id])
    @bucket_line_items=@bucket.bucket_line_items.page(params[:page]).per(100)
    respond_to do |format|
      format.html # show.html.erb
      format.text
      format.json { render json: @bucket }
    end
  end

  # GET /buckets/new
  # GET /buckets/new.json
  def new
    @bucket = Bucket.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bucket }
    end
  end

  # GET /buckets/1/edit
  def edit
    @bucket = Bucket.find(params[:id])
  end

  # POST /buckets
  # POST /buckets.json
  def create
    @bucket = Bucket.new(params[:bucket])


    respond_to do |format|
      if @bucket.save
        upload_results=@bucket.process_upload
        format.html { redirect_to @bucket, notice: 'Bucket was successfully created. ' + upload_results }
        format.json { render json: @bucket, status: :created, location: @bucket }
      else
        format.html { render action: "new" }
        format.json { render json: @bucket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buckets/1
  # PUT /buckets/1.json
  def update
    @bucket = Bucket.find(params[:id])

    respond_to do |format|
      if @bucket.update_attributes(params[:bucket])
        format.html { redirect_to @bucket, notice: 'Bucket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bucket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buckets/1
  # DELETE /buckets/1.json
  def destroy
    @bucket = Bucket.find(params[:id])
    @bucket.destroy

    respond_to do |format|
      format.html { redirect_to buckets_url }
      format.json { head :no_content }
    end
  end


  def smartdestroy
    @bucket = Bucket.find(params[:id])
    @old_name=@bucket.name
    @dest_bucket = Bucket.find(params[:dest_bucket])
    
    unless @bucket.id == @dest_bucket.id
      @bucket.bucket_line_items.each do |bli|
        bli.bucket=@dest_bucket
        bli.save!
      end
      
      @bucket.reload.destroy 
      @notice="Bucket #{@old_name} was successfully destroyed with savable line items moved to bucket <a href='#{url_for(@dest_bucket)}'>#{@dest_bucket}</a>"
      @success=true
    else 
      @notice="Something went wrong."
      @success=false
    end
    respond_to do |format|
      format.html { redirect_to buckets_url,notice: @notice.html_safe }
      format.json { head :no_content }
      format.js { }
    end
  end


  def hidden_actions
    @bucket = Bucket.find(params[:id])

    respond_to do |format|
      format.html {  }
      format.js { }
    end
  end






  private

  def hack_out_params
  end


  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
    %w[created_at name].include?(params[:sort]) ? params[:sort] : "created_at"
  end

end
