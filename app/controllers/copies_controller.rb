class CopiesController < ApplicationController
  before_filter :authenticate_user! 
  # GET /copies
  # GET /copies.json
  def index
    @copies = Copy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @copies }
    end
  end

  # GET /copies/1
  # GET /copies/1.json
  def show
    @copy = Copy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @copy }
    end
  end

  # GET /copies/new
  # GET /copies/new.json
  def new
    authorize! :new, @copy, :message => 'Not authorized to add.'
    @copy = Copy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @copy }
    end
  end

  # GET /copies/1/edit
  def edit
    authorize! :edit, @copy, :message => 'Not authorized to edit.'
    @copy = Copy.find(params[:id])
  end

  # POST /copies
  # POST /copies.json
  def create
    authorize! :new, @copy, :message => 'Not authorized to add.'
    @copy = Copy.new(params[:copy])

    respond_to do |format|
      if @copy.save
        format.html { redirect_to @copy, notice: 'Copy was successfully created.' }
        format.json { render json: @copy, status: :created, location: @copy }
      else
        format.html { render action: "new" }
        format.json { render json: @copy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /copies/1
  # PUT /copies/1.json
  def update
    authorize! :edit, @copy, :message => 'Not authorized to edit.'
    @copy = Copy.find(params[:id])

    respond_to do |format|
      if @copy.update_attributes(params[:copy])
        format.html { redirect_to @copy, notice: 'Copy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @copy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /copies/1
  # DELETE /copies/1.json
  def destroy
    authorize! :edit, @copy, :message => 'Not authorized to edit.'
    @copy = Copy.find(params[:id])
    @copy.destroy

    respond_to do |format|
      format.html { redirect_to copies_url }
      format.json { head :no_content }
    end
  end
end
