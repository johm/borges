class DistributorsController < ApplicationController

  before_filter :authenticate_user! 
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction


  # GET /distributors
  # GET /distributors.json
  def index
    @distributors = Distributor.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @distributors }
    end
  end

  # GET /distributors/1
  # GET /distributors/1.json
  def show
    @distributor = Distributor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @distributor }
    end
  end

  # GET /distributors/new
  # GET /distributors/new.json
  def new
    @distributor = Distributor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @distributor }
    end
  end

  # GET /distributors/1/edit
  def edit
    @distributor = Distributor.find(params[:id])
  end

  # POST /distributors
  # POST /distributors.json
  def create
    @distributor = Distributor.new(params[:distributor])

    respond_to do |format|
      if @distributor.save
        format.html { redirect_to @distributor, notice: 'Distributor was successfully created.' }
        format.json { render json: @distributor, status: :created, location: @distributor }
      else
        format.html { render action: "new" }
        format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /distributors/1
  # PUT /distributors/1.json
  def update
    @distributor = Distributor.find(params[:id])

    respond_to do |format|
      if @distributor.update_attributes(params[:distributor])
        format.html { redirect_to @distributor, notice: 'Distributor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributors/1
  # DELETE /distributors/1.json
  def destroy
    @distributor = Distributor.find(params[:id])
    if @distributor.purchase_orders.size == 0 && @distributor.return_orders.size == 0 && @distributor.invoices.size == 0 
        @distributor.destroy 
    end
    respond_to do |format|
      format.html { redirect_to distributors_url }
      format.json { head :no_content }
    end
  end

  def merge_orders_from
    @distributor = Distributor.find(params[:id])
    @unneeded_distributor_id=params[:unneeded_distributor_id]
    respond_to do |format|
      if @distributor.merge_stuff_from_distributor(@unneeded_distributor_id)
        format.html { redirect_to @distributor,notice: 'Successfully merged orders and deleted unneeded distributor.' } 
      else
        format.html { redirect_to @distributor,alert: 'I could not make the requested merge.' } 
      end
    end
  end



  private
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end
  def sort_column
    %w[created_at number id].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  

end
