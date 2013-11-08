class EventLocationsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:index,:show]
  load_and_authorize_resource

  # GET /event_locations
  # GET /event_locations.json
  def index
    @event_locations = EventLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_locations }
    end
  end

  # GET /event_locations/1
  # GET /event_locations/1.json
  def show
    @event_location = EventLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_location }
    end
  end

  # GET /event_locations/new
  # GET /event_locations/new.json
  def new
    @event_location = EventLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_location }
    end
  end

  # GET /event_locations/1/edit
  def edit
    @event_location = EventLocation.find(params[:id])
  end

  # POST /event_locations
  # POST /event_locations.json
  def create
    @event_location = EventLocation.new(params[:event_location])

    respond_to do |format|
      if @event_location.save
        format.html { redirect_to @event_location, notice: 'Event location was successfully created.' }
        format.json { render json: @event_location, status: :created, location: @event_location }
      else
        format.html { render action: "new" }
        format.json { render json: @event_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_locations/1
  # PUT /event_locations/1.json
  def update
    @event_location = EventLocation.find(params[:id])

    respond_to do |format|
      if @event_location.update_attributes(params[:event_location])
        format.html { redirect_to @event_location, notice: 'Event location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_locations/1
  # DELETE /event_locations/1.json
  def destroy
    @event_location = EventLocation.find(params[:id])
    @event_location.destroy

    respond_to do |format|
      format.html { redirect_to event_locations_url }
      format.json { head :no_content }
    end
  end
end
