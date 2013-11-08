class DashboardController < ApplicationController
  before_filter :authenticate_user! 
  authorize_resource :class => false

  autocomplete :publisher,:name,:full=>true,:display_value=>:name_and_id
  autocomplete :title_list,:name,:full=>true,:display_value=>:name

  # GET /titles
  # GET /titles.json

  def index
    @purchase_orders=PurchaseOrder.order("created_at DESC").limit(10)
    @invoices=Invoice.order("created_at DESC").limit(10)
    @title_lists=TitleList.order("created_at DESC").limit(10)
    @categories=Category.order("name DESC")
    @titles=Title.order("created_at DESC").limit(50)
    @owners=Owner.order("name asc")
  end

  def content 
    @top_level_pages=Page.where("parent_id is ?",nil)
    @posts=Post.order("created_at desc")  #TODO pagination
    @post_categories=PostCategory.order("name asc")  #TODO pagination
  end

  def manage_calendar
    @events=Event.where("event_start > ?",Time.now)
    @event_locations=EventLocation.all
  end

  def titles
    if ! params[:searchquery].blank? 
      searchquery=params[:searchquery]
      @searchquery=searchquery
      @title_search = Title.search do
        fulltext searchquery
        paginate :page => params[:page], :per_page => 20
      end
      @titles=@title_search.results
    else
      @titles = Title.page(params[:page]).per(20)
    end
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end


end
