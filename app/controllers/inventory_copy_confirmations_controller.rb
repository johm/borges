class InventoryCopyConfirmationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource


  # GET /inventory_copy_confirmations
  # GET /inventory_copy_confirmations.json
  def index
    @inventory_copy_confirmations = InventoryCopyConfirmation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_copy_confirmations }
    end
  end

  # GET /inventory_copy_confirmations/1
  # GET /inventory_copy_confirmations/1.json
  def show
    @inventory_copy_confirmation = InventoryCopyConfirmation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_copy_confirmation }
    end
  end

  # GET /inventory_copy_confirmations/new
  # GET /inventory_copy_confirmations/new.json
  def new
    @inventory_copy_confirmation = InventoryCopyConfirmation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_copy_confirmation }
    end
  end

  # GET /inventory_copy_confirmations/1/edit
  def edit
    @inventory_copy_confirmation = InventoryCopyConfirmation.find(params[:id])
  end

  # POST /inventory_copy_confirmations
  # POST /inventory_copy_confirmations.json
  def create
    @inventory_copy_confirmation = InventoryCopyConfirmation.new(params[:inventory_copy_confirmation])
    @inventory_copy_confirmation.status=true
    respond_to do |format|
      if @inventory_copy_confirmation.save
        format.html { redirect_to @inventory_copy_confirmation, notice: 'Inventory copy confirmation was successfully created.' }
        format.json { render json: @inventory_copy_confirmation, status: :created, location: @inventory_copy_confirmation }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @inventory_copy_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inventory_copy_confirmations/1
  # PUT /inventory_copy_confirmations/1.json
  def update
    @inventory_copy_confirmation = InventoryCopyConfirmation.find(params[:id])

    respond_to do |format|
      if @inventory_copy_confirmation.update_attributes(params[:inventory_copy_confirmation])
        format.html { redirect_to @inventory_copy_confirmation, notice: 'Inventory copy confirmation was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory_copy_confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_copy_confirmations/1
  # DELETE /inventory_copy_confirmations/1.json
  def destroy
    @inventory_copy_confirmation = InventoryCopyConfirmation.find(params[:id])
    @inventory_copy_confirmation.destroy

    respond_to do |format|
      format.html { redirect_to inventory_copy_confirmations_url }
      format.json { head :no_content }
    end
  end
end
