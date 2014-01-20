class EventStaffersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  autocomplete :event_staffer,:name,:full=>true,:display_value=>:name_email,:extra_data=>[:email]
  
  # GET /event_staffers
  # GET /event_staffers.json
  def index
    @event_staffers = EventStaffer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_staffers }
    end
  end

  # GET /event_staffers/1
  # GET /event_staffers/1.json
  def show
    @event_staffer = EventStaffer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_staffer }
    end
  end

  # GET /event_staffers/new
  # GET /event_staffers/new.json
  def new
    @event_staffer = EventStaffer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_staffer }
    end
  end

  # GET /event_staffers/1/edit
  def edit
    @event_staffer = EventStaffer.find(params[:id])
  end

  # POST /event_staffers
  # POST /event_staffers.json
  def create
    @event_staffer = EventStaffer.new(params[:event_staffer])

    respond_to do |format|
      if @event_staffer.save
        format.html { redirect_to @event_staffer, notice: 'Event staffer was successfully created.' }
        format.json { render json: @event_staffer, status: :created, location: @event_staffer }
      else
        format.html { render action: "new" }
        format.json { render json: @event_staffer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_staffers/1
  # PUT /event_staffers/1.json
  def update
    @event_staffer = EventStaffer.find(params[:id])

    respond_to do |format|
      if @event_staffer.update_attributes(params[:event_staffer])
        format.html { redirect_to @event_staffer, notice: 'Event staffer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_staffer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_staffers/1
  # DELETE /event_staffers/1.json
  def destroy
    @event_staffer = EventStaffer.find(params[:id])
    @event_staffer.destroy

    respond_to do |format|
      format.html { redirect_to event_staffers_url }
      format.json { head :no_content }
    end
  end
end
