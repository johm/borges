class DashboardController < ApplicationController
  before_filter :authenticate_user! 
  authorize_resource :class => false

  autocomplete :publisher,:name,:full=>true,:display_value=>:name_and_id
  autocomplete :title_list,:name,:full=>true,:display_value=>:name

  # GET /titles
  # GET /titles.json

  def index
    @purchase_orders=PurchaseOrder.order("created_at DESC").limit(10)
    @sale_orders=SaleOrder.order("created_at DESC").limit(10)
    @invoices=Invoice.order("created_at DESC").limit(10)
    @title_lists=TitleList.includes(:titles => [:editions => [:copies]]).order("created_at DESC").limit(10)
    @categories=Category.includes(:titles => [:editions => [:copies]]).order("name DESC")
    @titles=Title.includes(:editions => [:copies]).order("created_at DESC").limit(50)
    @owners=Owner.order("name asc")
  end

  def search 
  end

  def sales 
    @sales_by_date=SaleOrder.where(:posted => true).order("created_at asc").where("posted_when > ? ",8.days.ago ).group_by{ |so| so.posted_when.in_time_zone("New York").to_date } 
    
    @days=@sales_by_date.keys
    
    @saleschart = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name=>'Books & Merch',:data=> @days.collect {|d| @sales_by_date[d].inject(0) {|sum,s| sum+(s.total).to_f} } )
      f.title({ :text=>"Sales"})
      f.xAxis(:categories => @days)
              

      #f.options[:chart][:defaultSeriesType] = "line"

      
  end    

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
