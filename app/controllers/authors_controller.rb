class AuthorsController < ApplicationController
  before_filter :authenticate_user!, :except => [:redirector,:show] 
  load_and_authorize_resource

  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authors }
    end
  end

  def redirector 
    @author = Author.find(params[:id])
    redirect_to @author
  end



  
  # GET /authors/1
  # GET /authors/1.json
  def show
    @author = Author.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @author }
    end
  end

  # GET /authors/new
  # GET /authors/new.json
  def new
    @author = Author.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @author }
    end
  end

  # GET /authors/1/edit
  def edit
    @author = Author.find(params[:id])
  end

  # POST /authors
  # POST /authors.json
  def create
    @author = Author.new(params[:author])

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: 'Author was successfully created.' }
        format.json { render json: @author, status: :created, location: @author }
      else
        format.html { render action: "new" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /authors/1
  # PUT /authors/1.json
  def update
    @author = Author.find(params[:id])


    if ! params[:merge_author].blank?
      @old_author_string = @author.name_and_id
      @author_to_keep=Author.find(params[:merge_author])
      @author.contributions.each do |c|
        c.author=@author_to_keep
        c.save!
      end
      @author.destroy

      respond_to do |format|
        format.html { redirect_to @author_to_keep, notice: "Author #{@old_author_string} was successfully merged here, and deleted." }
      end
    else 
      respond_to do |format|
        if @author.update_attributes(params[:author])
          format.html { redirect_to @author, notice: 'Author was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @author.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def search 
    @author_search_object = SearchObject.new(params[:search_object])
    author_search_object = @author_search_object

    @author_search = Author.search do
      fulltext author_search_object.full_name do
        fields(:full_name)
      end
      paginate :page => params[:page], :per_page => 200
    end
    @authors=@author_search.results
    
    respond_to do |format|
      format.html {render 'adminsearch'} # search.html.erb
      format.json { render json: @authors }
    end

  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    @author = Author.find(params[:id])
    @author.destroy

    respond_to do |format|
      format.html { redirect_to authors_url }
      format.json { head :no_content }
    end
  end
end
