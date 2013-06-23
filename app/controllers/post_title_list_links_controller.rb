class PostTitleListLinksController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource
  
  # GET /post_title_list_links
  # GET /post_title_list_links.json
  def index
    @post_title_list_links = PostTitleListLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @post_title_list_links }
    end
  end

  # GET /post_title_list_links/1
  # GET /post_title_list_links/1.json
  def show
    @post_title_list_link = PostTitleListLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post_title_list_link }
    end
  end

  # GET /post_title_list_links/new
  # GET /post_title_list_links/new.json
  def new
    @post_title_list_link = PostTitleListLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post_title_list_link }
    end
  end

  # GET /post_title_list_links/1/edit
  def edit
    @post_title_list_link = PostTitleListLink.find(params[:id])
  end

  # POST /post_title_list_links
  # POST /post_title_list_links.json
  def create
    @post_title_list_link = PostTitleListLink.new(params[:post_title_list_link])

    respond_to do |format|
      if @post_title_list_link.save
        format.html { redirect_to @post_title_list_link, notice: 'Post title list link was successfully created.' }
        format.json { render json: @post_title_list_link, status: :created, location: @post_title_list_link }
      else
        format.html { render action: "new" }
        format.json { render json: @post_title_list_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /post_title_list_links/1
  # PUT /post_title_list_links/1.json
  def update
    @post_title_list_link = PostTitleListLink.find(params[:id])

    respond_to do |format|
      if @post_title_list_link.update_attributes(params[:post_title_list_link])
        format.html { redirect_to @post_title_list_link, notice: 'Post title list link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post_title_list_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_title_list_links/1
  # DELETE /post_title_list_links/1.json
  def destroy
    @post_title_list_link = PostTitleListLink.find(params[:id])
    @post_title_list_link.destroy

    respond_to do |format|
      format.html { redirect_to post_title_list_links_url }
      format.json { head :no_content }
    end
  end
end
