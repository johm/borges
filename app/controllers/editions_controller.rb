class EditionsController < ApplicationController
  before_filter :authenticate_user! , :except=>[:show,:byisbn]
  load_and_authorize_resource
  autocomplete :title,:title,:full=>true,:display_value=>:title_and_id,:limit => 20
  before_filter :hack_out_params , :only=>[:create,:update]
  

  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @editions }
    end
  end

  def byisbn 
    isbn=params[:isbn]
    if ! isbn.nil?
      @edition = Edition.where('isbn13 = ? or isbn10 = ?',isbn,isbn).first
      if ! @edition.nil?
        @title = @edition.title 
      end
    end

    respond_to do |format|
      if @edition && @title
        format.html { redirect_to title_path(@title)}
      else
        format.html { redirect_to '/books/', notice: "We couldn't find that title in our system...but here's some other things you might like!  And thanks for supporting local independent bookstores!" }
      end
    end
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
    @edition = Edition.find(params[:id])
    @title = @edition.title
    respond_to do |format|
      format.html { redirect_to title_path(@title,:edition_id=>@edition)}
      format.json { render json: @edition }
    end
  end

  # GET /editions/new
  # GET /editions/new.json
  def new
    @edition = Edition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @edition }
    end
  end

  # GET /editions/1/edit
  def edit
    @edition = Edition.find(params[:id])
  end

  # POST /editions
  # POST /editions.json
  def create
    @edition = Edition.new(params[:edition])

    respond_to do |format|
      if @edition.save
        format.html { redirect_to @edition, notice: 'Edition was successfully created.' }
        format.json { render json: @edition, status: :created, location: @edition }
      else
        format.html { render action: "new" }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /editions/1
  # PUT /editions/1.json
  def update
    @edition = Edition.find(params[:id])

    respond_to do |format|
      if @edition.update_attributes(params[:edition])
        format.html { redirect_to @edition, notice: 'Edition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editions/1
  # DELETE /editions/1.json
  def destroy
    @edition = Edition.find(params[:id])
    @edition.destroy

    respond_to do |format|
      format.html { redirect_to editions_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @edition_search=Edition.search do
      fulltext params[:term]
    end
    
    @editions_data=@edition_search.results.collect do |edition|
      hash = {"id" => edition.id.to_s, "label" => "#{edition.title.title} #{edition.number} (#{edition.year_of_publication}) {#{edition.format}} [#{edition.isbn13}]", "value" => "#{edition.title.title} #{edition.number} (#{edition.year_of_publication}) {#{edition.format}} [#{edition.isbn13}]"}
    end
    respond_to do |format|
      format.json { render json: @editions_data }
    end
  end

  def add_to_purchase_order
    @edition = Edition.find(params[:id])
    @purchase_order = PurchaseOrder.find(params[:purchase_order])
    line=PurchaseOrderLineItem.new
    line.quantity=1
    line.edition=@edition
    line.purchase_order=@purchase_order
    line.received=0
    line.save!

    respond_to do |format| 
      format.html { redirect_to @edition.title, notice: "Edition was successfully added to purchase order <a href='#{url_for(@purchase_order)}'>#{@purchase_order}</a>".html_safe }
      format.js {}
    end
  end



  def add_to_title_list
    @edition = Edition.find(params[:id])
    @title_list = TitleList.find(params[:title_list])
    
    if ! @title_list.titles.include? @edition.title
      @title_list.titles << @edition.title 
    else
      @title_list.touch #touch it anyway  
    end      

    respond_to do |format| 
      format.html { redirect_to @edition.title, notice: "Title was successfully added to title list <a href='#{url_for(@title_list)}'>#{@title_list.name}</a>".html_safe }
      format.js {}
    end
  end


  def add_to_category
    @edition = Edition.find(params[:id])
    @category = Category.find(params[:category])
    
    if ! @category.titles.include? @edition.title
      @category.titles << @edition.title
    else
      @category.touch #touch it anyway
    end

    respond_to do |format| 
      format.html { redirect_to @edition.title, notice: "Title was successfully added to category <a href='#{url_for(@category)}'>#{@category.name}</a>".html_safe }
      format.js {}
    end
  end




  def hidden_actions
    @edition = Edition.find(params[:id])

    respond_to do |format|
      format.html {  }
      format.js { }
    end
  end



    private

  def hack_out_params
    params[:edition].delete :title
    params[:edition].delete :publisher
  end


end
