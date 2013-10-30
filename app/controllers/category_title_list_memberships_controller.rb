class CategoryTitleListMembershipsController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource


  # GET /category_title_list_memberships
  # GET /category_title_list_memberships.json
  def index
    @category_title_list_memberships = CategoryTitleListMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @category_title_list_memberships }
    end
  end

  # GET /category_title_list_memberships/1
  # GET /category_title_list_memberships/1.json
  def show
    @category_title_list_membership = CategoryTitleListMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category_title_list_membership }
    end
  end

  # GET /category_title_list_memberships/new
  # GET /category_title_list_memberships/new.json
  def new
    @category_title_list_membership = CategoryTitleListMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category_title_list_membership }
    end
  end

  # GET /category_title_list_memberships/1/edit
  def edit
    @category_title_list_membership = CategoryTitleListMembership.find(params[:id])
  end

  # POST /category_title_list_memberships
  # POST /category_title_list_memberships.json
  def create
    @category_title_list_membership = CategoryTitleListMembership.new(params[:category_title_list_membership])

    respond_to do |format|
      if @category_title_list_membership.save
        format.html { redirect_to @category_title_list_membership, notice: 'Category title list membership was successfully created.' }
        format.json { render json: @category_title_list_membership, status: :created, location: @category_title_list_membership }
      else
        format.html { render action: "new" }
        format.json { render json: @category_title_list_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /category_title_list_memberships/1
  # PUT /category_title_list_memberships/1.json
  def update
    @category_title_list_membership = CategoryTitleListMembership.find(params[:id])

    respond_to do |format|
      if @category_title_list_membership.update_attributes(params[:category_title_list_membership])
        format.html { redirect_to @category_title_list_membership, notice: 'Category title list membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category_title_list_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_title_list_memberships/1
  # DELETE /category_title_list_memberships/1.json
  def destroy
    @category_title_list_membership = CategoryTitleListMembership.find(params[:id])
    @category_title_list_membership.destroy

    respond_to do |format|
      format.html { redirect_to category_title_list_memberships_url }
      format.json { head :no_content }
    end
  end
end
