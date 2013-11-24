# -*- coding: utf-8 -*-
class CopiesController < ApplicationController
  before_filter :authenticate_user! 
  load_and_authorize_resource

  # GET /copies
  # GET /copies.json
  def index
    @edition = Edition.find(params[:edition_id])
    @copies = @edition.copies

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @copies }
    end
  end

  # GET /copies/1
  # GET /copies/1.json
  def show
    @copy = Copy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @copy }
    end
  end

  # GET /copies/new
  # GET /copies/new.json
  def new
    @copy = Copy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @copy }
    end
  end

  # GET /copies/1/edit
  def edit
    @copy = Copy.find(params[:id])
  end

  # POST /copies
  # POST /copies.json
  def create
    @copy = Copy.new(params[:copy])

    respond_to do |format|
      if @copy.save
        format.html { redirect_to @copy, notice: 'Copy was successfully created.' }
        format.json { render json: @copy, status: :created, location: @copy }
      else
        format.html { render action: "new" }
        format.json { render json: @copy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /copies/1
  # PUT /copies/1.json
  def update
    @copy = Copy.find(params[:id])

    respond_to do |format|
      if @copy.update_attributes(params[:copy])
        format.html { redirect_to @copy, notice: 'Copy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @copy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /copies/1
  # DELETE /copies/1.json
  def destroy
    @copy = Copy.find(params[:id])
    @copy.destroy

    respond_to do |format|
      format.html { redirect_to copies_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @edition_search=Edition.search do
      fulltext params[:term]
    end
    
    @copies_data=@edition_search.results.collect do |edition|
      @copies=edition.copies.instock.order("price_in_cents desc")
      # you can't sell a copy someone else is trying to sell!
      copies_on_sale_orders= SaleOrder.where(:posted=>false).collect {|so| so.sale_order_line_items.collect {|soli| soli.copy_id}}.flatten
      @copies=@copies.find_all {|c| !(copies_on_sale_orders.include? c.id)} 
      @copies.collect do |copy|
        hash = {"id" => copy.id.to_s, "label" => "#{copy.info}—#{edition.title.title} (#{edition.year_of_publication}) {#{edition.number} #{edition.format}} [#{edition.isbn13}]", "value" => "#{copy.info}—#{edition.title.title} (#{edition.year_of_publication}) {#{edition.number} #{edition.format}} [#{edition.isbn13}]"}
      end
    end
    respond_to do |format|
      format.json { render json: @copies_data.flatten }
    end
  end
  
end
