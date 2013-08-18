class EditionsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource
  autocomplete :title,:title,:full=>true,:display_value=>:title_and_id
  before_filter :hack_out_params , :only=>[:create,:update]
  

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
    @edition = Edition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @edition }
    end
  end

  # GET /editions/1/edit
  def edit
    @edition = Edition.find(params[:id])
  end

  # POST /editions
  # POST /editions.json
  def create
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
    @edition = Edition.find(params[:id])
    @edition.destroy

    respond_to do |format|
      format.html { redirect_to editions_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @edition_search=Edition.search do
      fulltext params[:term]
    end
    
    @editions_data=@edition_search.results.collect do |edition|
      hash = {"id" => edition.id.to_s, "label" => "#{edition.title.title} (#{edition.year_of_publication}) {#{edition.format}} [#{edition.isbn13}]", "value" => "#{edition.title.title} (#{edition.year_of_publication}) {#{edition.format}} [#{edition.isbn13}]"}
    end
    respond_to do |format|
      format.json { render json: @editions_data }
    end
  end


    private

  def hack_out_params
    params[:edition].delete :title
    params[:edition].delete :publisher
  end


end
