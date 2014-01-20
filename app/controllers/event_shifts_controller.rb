class EventShiftsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /event_shifts
  # GET /event_shifts.json
  def index
    @event_shifts = EventShift.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_shifts }
    end
  end

  # GET /event_shifts/1
  # GET /event_shifts/1.json
  def show
    @event_shift = EventShift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_shift }
    end
  end

  # GET /event_shifts/new
  # GET /event_shifts/new.json
  def new
    @event_shift = EventShift.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_shift }
    end
  end

  # GET /event_shifts/1/edit
  def edit
    @event_shift = EventShift.find(params[:id])
  end

  # POST /event_shifts
  # POST /event_shifts.json
  def create
    @event_shift = EventShift.new(params[:event_shift])

    respond_to do |format|
      if @event_shift.save
        format.html { redirect_to @event_shift, notice: 'Event shift was successfully created.' }
        format.json { render json: @event_shift, status: :created, location: @event_shift }
      else
        format.html { render action: "new" }
        format.json { render json: @event_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_shifts/1
  # PUT /event_shifts/1.json
  def update
    @event_shift = EventShift.find(params[:id])

    respond_to do |format|
      if @event_shift.update_attributes(params[:event_shift])
        format.html { redirect_to @event_shift, notice: 'Event shift was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_shifts/1
  # DELETE /event_shifts/1.json
  def destroy
    @event_shift = EventShift.find(params[:id])
    @event_shift.destroy

    respond_to do |format|
      format.html { redirect_to event_shifts_url }
      format.json { head :no_content }
    end
  end
end
