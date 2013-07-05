class TitleCategoryMembershipsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource


  # GET /title_category_memberships
  # GET /title_category_memberships.json
  def index
    @title_category_memberships = TitleCategoryMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @title_category_memberships }
    end
  end

  # GET /title_category_memberships/1
  # GET /title_category_memberships/1.json
  def show
    @title_category_membership = TitleCategoryMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @title_category_membership }
    end
  end

  # GET /title_category_memberships/new
  # GET /title_category_memberships/new.json
  def new
    @title_category_membership = TitleCategoryMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @title_category_membership }
    end
  end

  # GET /title_category_memberships/1/edit
  def edit
    @title_category_membership = TitleCategoryMembership.find(params[:id])
  end

  # POST /title_category_memberships
  # POST /title_category_memberships.json
  def create
    @title_category_membership = TitleCategoryMembership.new(params[:title_category_membership])

    respond_to do |format|
      if @title_category_membership.save
        format.html { redirect_to @title_category_membership, notice: 'Title category membership was successfully created.' }
        format.json { render json: @title_category_membership, status: :created, location: @title_category_membership }
      else
        format.html { render action: "new" }
        format.json { render json: @title_category_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /title_category_memberships/1
  # PUT /title_category_memberships/1.json
  def update
    @title_category_membership = TitleCategoryMembership.find(params[:id])

    respond_to do |format|
      if @title_category_membership.update_attributes(params[:title_category_membership])
        format.html { redirect_to @title_category_membership, notice: 'Title category membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @title_category_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /title_category_memberships/1
  # DELETE /title_category_memberships/1.json
  def destroy
    @title_category_membership = TitleCategoryMembership.find(params[:id])
    @title_category_membership.destroy

    respond_to do |format|
      format.html { redirect_to title_category_memberships_url }
      format.json { head :no_content }
    end
  end
end
