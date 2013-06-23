class TitlesController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :hack_out_params , :only=>[:create,:update]
  load_and_authorize_resource
  autocomplete :publisher,:name,:full=>true,:display_value=>:name_and_id
  autocomplete :title_list,:name,:full=>true,:display_value=>:name

  # GET /titles
  # GET /titles.json
  def index
    @titles = Title.page(params[:page]).per(10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @titles }
    end
  end

  # GET /titles/1
  # GET /titles/1.json
  def show
    @title = Title.find(params[:id])
    @edition = params[:edition_id] ? Edition.find(params[:edition_id]) : @title.latest_published_edition

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.json
  def new
    @title = Title.new
    @title.contributions << Contribution.new
    @title.editions << Edition.new(:list_price => 0)
    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @title }
    end
  end

  # GET /titles/1/edit
  def edit
    @title = Title.find(params[:id])
  end

  # POST /titles
  # POST /titles.json
  def create
    
    # do a dance to set the publisher from a string
    if (params[:title][:editions_attributes]["0"][:publisher_id].blank? && @publisher_name)
      params[:title][:editions_attributes]["0"][:publisher_id]=Publisher.find_or_create_by_name(@publisher_name).id
    end
      
    # do a more complicated dance to deal with contributions and authornames
    
    params[:title][:contributions_attributes].each do |k,v|
      params[:title][:contributions_attributes][k][:author_id]=Author.find_or_create_by_full_name(@authornames[k]).id
    end


    @title = Title.new(params[:title])
    

    respond_to do |format|
      if @title.save
        format.html { redirect_to @title, notice: "Title was successfully created." }
        format.json { render json: @title, status: :created, location: @title }
      else
        format.html { render action: "new" }
        format.json { render json: @title.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.json
  def update
    @title = Title.find(params[:id])
    
    respond_to do |format|
      if @title.update_attributes(params[:title])
        format.html { redirect_to @title, notice: 'Title was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @title.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.json
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to titles_url }
      format.json { head :no_content }
    end
  end

  private

  def hack_out_params
    params[:title][:title_list_memberships_attributes].each do |k,v| 
      params[:title][:title_list_memberships_attributes][k].delete :title_list
    end
    
    
    @publisher_name=params[:title][:editions_attributes]["0"][:publisher]
    params[:title][:editions_attributes].each do |k,v|
      params[:title][:editions_attributes][k].delete :publisher
    end

    @authornames={}
    params[:title][:contributions_attributes].each do |k,v| 
      @authornames[k]=v[:author]
      params[:title][:contributions_attributes][k].delete :author
    end
    
  end

end
