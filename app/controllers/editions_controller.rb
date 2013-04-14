class EditionsController < ApplicationController
  before_filter :authenticate_user! 
  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @editions }
    end
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
    @edition = Edition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @edition }
    end
  end

  # GET /editions/new
  # GET /editions/new.json
  def new
    authorize! :new, @edit, :message => 'Not authorized to add.'
    @edition = Edition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @edition }
    end
  end

  # GET /editions/1/edit
  def edit
    authorize! :edit, @edit, :message => 'Not authorized to edit.'
    @edition = Edition.find(params[:id])
  end

  # POST /editions
  # POST /editions.json
  def create
    authorize! :create, @edit, :message => 'Not authorized to edit.'
    @edition = Edition.new(params[:edition])

    respond_to do |format|
      if @edition.save
        format.html { redirect_to @edition, notice: 'Edition was successfully created.' }
        format.json { render json: @edition, status: :created, location: @edition }
      else
        format.html { render action: "new" }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /editions/1
  # PUT /editions/1.json
  def update
    authorize! :update, @edit, :message => 'Not authorized to edit.'
    @edition = Edition.find(params[:id])

    respond_to do |format|
      if @edition.update_attributes(params[:edition])
        format.html { redirect_to @edition, notice: 'Edition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editions/1
  # DELETE /editions/1.json
  def destroy
    authorize! :destroy, @edit, :message => 'Not authorized to edit.'
    @edition = Edition.find(params[:id])
    @edition.destroy

    respond_to do |format|
      format.html { redirect_to editions_url }
      format.json { head :no_content }
    end
  end
end
