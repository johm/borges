class EventsController < ApplicationController
  autocomplete :event_location,:title,:full=>true,:display_value=>:name_and_id
  before_filter :authenticate_user!, :except=>[:index,:show,:calendar]
  before_filter :hack_out_params , :only=>[:create,:update]

  load_and_authorize_resource
  # GET /events
  # GET /events.json

  def index
    @year = (params[:year] || DateTime.now.year).to_i
    @month = (params[:month] || DateTime.now.month).to_i
    
    @events = Event.by_year(@year).by_month(@month).where(:published=>true).order("event_start asc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    now=DateTime.now
    @event.event_start=DateTime.new(now.year,now.month,now.day,19,30)
    @event.event_end=DateTime.new(now.year,now.month,now.day,21,30)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create

    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
  
  def calendar
    cal=MyCalendar.new(Event.where("event_start > ?",DateTime.now))
    respond_to do |format|
      format.html 
      format.ics { render :text => cal.export  }
    end
  end


  private
  
  def hack_out_params
    unless params[:event].nil?
      if params[:event].has_key?(:event_location)
        params[:event].delete :event_location
      end
    end
  end


end
