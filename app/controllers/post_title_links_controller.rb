class PostTitleLinksController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource

  # GET /post_title_links
  # GET /post_title_links.json
  def index
    @post_title_links = PostTitleLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @post_title_links }
    end
  end

  # GET /post_title_links/1
  # GET /post_title_links/1.json
  def show
    @post_title_link = PostTitleLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post_title_link }
    end
  end

  # GET /post_title_links/new
  # GET /post_title_links/new.json
  def new
    @post_title_link = PostTitleLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post_title_link }
    end
  end

  # GET /post_title_links/1/edit
  def edit
    @post_title_link = PostTitleLink.find(params[:id])
  end

  # POST /post_title_links
  # POST /post_title_links.json
  def create
    @post_title_link = PostTitleLink.new(params[:post_title_link])

    respond_to do |format|
      if @post_title_link.save
        format.html { redirect_to @post_title_link, notice: 'Post title link was successfully created.' }
        format.json { render json: @post_title_link, status: :created, location: @post_title_link }
      else
        format.html { render action: "new" }
        format.json { render json: @post_title_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /post_title_links/1
  # PUT /post_title_links/1.json
  def update
    @post_title_link = PostTitleLink.find(params[:id])

    respond_to do |format|
      if @post_title_link.update_attributes(params[:post_title_link])
        format.html { redirect_to @post_title_link, notice: 'Post title link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post_title_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_title_links/1
  # DELETE /post_title_links/1.json
  def destroy
    @post_title_link = PostTitleLink.find(params[:id])
    @post_title_link.destroy

    respond_to do |format|
      format.html { redirect_to post_title_links_url }
      format.json { head :no_content }
    end
  end
end
