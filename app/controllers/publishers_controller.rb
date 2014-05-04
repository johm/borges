class PublishersController < ApplicationController
  before_filter :authenticate_user! , :except=>[:show]
  load_and_authorize_resource

  # GET /publishers
  # GET /publishers.json
  def index
    @publishers = Publisher.all.order("name") 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @publishers }
    end
  end

  # GET /publishers/1
  # GET /publishers/1.json
  def show
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @publisher }
    end
  end

  # GET /publishers/new
  # GET /publishers/new.json
  def new
    @publisher = Publisher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @publisher }
    end
  end

  # GET /publishers/1/edit
  def edit
    @publisher = Publisher.find(params[:id])
  end

  # POST /publishers
  # POST /publishers.json
  def create
    @publisher = Publisher.new(params[:publisher])

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, notice: 'Publisher was successfully created.' }
        format.json { render json: @publisher, status: :created, location: @publisher }
      else
        format.html { render action: "new" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /publishers/1
  # PUT /publishers/1.json
  def update
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        format.html { redirect_to @publisher, notice: 'Publisher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  def merge_editions_from
    @publisher = Publisher.find(params[:id])
    @unneeded_publisher_id=params[:unneeded_publisher_id]
    respond_to do |format|
      if @publisher.merge_stuff_from_publisher(@unneeded_publisher_id)
        format.html { redirect_to @publisher,notice: 'Successfully merged editions and deleted unneeded publisher.' } 
      else
        format.html { redirect_to @publisher,alert: 'I could not make the requested merge.' } 
      end
    end
  end

  # DELETE /publishers/1
  # DELETE /publishers/1.json
  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy

    respond_to do |format|
      format.html { redirect_to publishers_url }
      format.json { head :no_content }
    end
  end
end
