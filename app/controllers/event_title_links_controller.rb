class EventTitleLinksController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource

  # GET /event_title_links
  # GET /event_title_links.json
  def index
    @event_title_links = EventTitleLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_title_links }
    end
  end

  # GET /event_title_links/1
  # GET /event_title_links/1.json
  def show
    @event_title_link = EventTitleLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_title_link }
    end
  end

  # GET /event_title_links/new
  # GET /event_title_links/new.json
  def new
    @event_title_link = EventTitleLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_title_link }
    end
  end

  # GET /event_title_links/1/edit
  def edit
    @event_title_link = EventTitleLink.find(params[:id])
  end

  # EVENT /event_title_links
  # EVENT /event_title_links.json
  def create
    @event_title_link = EventTitleLink.new(params[:event_title_link])

    respond_to do |format|
      if @event_title_link.save
        format.html { redirect_to @event_title_link, notice: 'Event title link was successfully created.' }
        format.json { render json: @event_title_link, status: :created, location: @event_title_link }
      else
        format.html { render action: "new" }
        format.json { render json: @event_title_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_title_links/1
  # PUT /event_title_links/1.json
  def update
    @event_title_link = EventTitleLink.find(params[:id])

    respond_to do |format|
      if @event_title_link.update_attributes(params[:event_title_link])
        format.html { redirect_to @event_title_link, notice: 'Event title link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_title_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_title_links/1
  # DELETE /event_title_links/1.json
  def destroy
    @event_title_link = EventTitleLink.find(params[:id])
    @event_title_link.destroy

    respond_to do |format|
      format.html { redirect_to event_title_links_url }
      format.json { head :no_content }
    end
  end
end
