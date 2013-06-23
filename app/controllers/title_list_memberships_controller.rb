class TitleListMembershipsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource

  # GET /title_list_memberships
  # GET /title_list_memberships.json
  def index
    @title_list_memberships = TitleListMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @title_list_memberships }
    end
  end

  # GET /title_list_memberships/1
  # GET /title_list_memberships/1.json
  def show
    @title_list_membership = TitleListMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @title_list_membership }
    end
  end

  # GET /title_list_memberships/new
  # GET /title_list_memberships/new.json
  def new
    @title_list_membership = TitleListMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @title_list_membership }
    end
  end

  # GET /title_list_memberships/1/edit
  def edit
    @title_list_membership = TitleListMembership.find(params[:id])
  end

  # POST /title_list_memberships
  # POST /title_list_memberships.json
  def create
    @title_list_membership = TitleListMembership.new(params[:title_list_membership])

    respond_to do |format|
      if @title_list_membership.save
        format.html { redirect_to @title_list_membership, notice: 'Title list membership was successfully created.' }
        format.json { render json: @title_list_membership, status: :created, location: @title_list_membership }
      else
        format.html { render action: "new" }
        format.json { render json: @title_list_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /title_list_memberships/1
  # PUT /title_list_memberships/1.json
  def update
    @title_list_membership = TitleListMembership.find(params[:id])

    respond_to do |format|
      if @title_list_membership.update_attributes(params[:title_list_membership])
        format.html { redirect_to @title_list_membership, notice: 'Title list membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @title_list_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /title_list_memberships/1
  # DELETE /title_list_memberships/1.json
  def destroy
    @title_list_membership = TitleListMembership.find(params[:id])
    @title_list_membership.destroy

    respond_to do |format|
      format.html { redirect_to title_list_memberships_url }
      format.json { head :no_content }
    end
  end
end
