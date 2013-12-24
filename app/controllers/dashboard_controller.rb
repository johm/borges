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
    @return_orders=ReturnOrder.order("created_at DESC").limit(10)
    @invoices=Invoice.order("created_at DESC").limit(10)
    @title_lists=TitleList.includes(:titles => [:editions => [:copies]]).order("created_at DESC").limit(10)
    @categories=Category.includes(:titles => [:editions => [:copies]]).order("name DESC")
    @titles=Title.includes(:editions => [:copies]).order("created_at DESC").limit(50)
    @owners=Owner.order("name asc")
  end

  def search 
  end

  def sales 
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date

    @sales_by_date=SaleOrder.includes(:sale_order_line_items => [:copy => [:edition => [:title]]]).where(:posted => true).order("created_at asc").where("posted_when > ? && posted_when < ?",@date_range_object.range_start,@date_range_object.range_end+1.days).group_by{ |so| so.posted_when.to_date }

    @days=@sales_by_date.keys.sort
    
    @saleschart = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name=>'Books & Merch',:data=> @days.collect {|d| @sales_by_date[d].inject(0) {|sum,s| sum+(s.subtotal_after_discount).to_f} } )
      f.title({ :text=>"Sales"})
      f.xAxis(:categories => @days)
              
      @revenue=@days.inject(Money.new(0)) {|sum,d| sum + @sales_by_date[d].inject(Money.new(0)) {|sum2,s| sum2 + s.total} }
      @cost=@days.inject(Money.new(0)) {|sum,d| sum + @sales_by_date[d].inject(Money.new(0)) {|sum2,s| sum2 + s.cost} }
      
      @titles_sold_with_count=@days.collect {|d| @sales_by_date[d].collect {|s| s.sale_order_line_items.collect {|li| li.copy.edition.title  }}}.flatten.flatten.flatten.inject(Hash.new(0)) {|h,i| h[i] += 1; h}.sort_by{|k,v| v}.reverse      
      
      


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

  def consignment
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date
    @date_range_object.owner=Owner.find(params[:date_range_object][:owner_id]) rescue Owner.first
    
    @sales=SaleOrder.where(:posted => true).order("created_at asc").where("posted_when > ? && posted_when < ?",@date_range_object.range_start,@date_range_object.range_end+1.days)
    
    @cost=@sales.inject(Money.new(0)) {|sum2,s| sum2 + s.cost_by_owner(@date_range_object.owner)}
    




  end

  def daily 
    @day=params[:day] ? Date.parse(params[:day]) : DateTime.now.to_date
    @sales_for_day=SaleOrder.where(:posted => true).order("created_at asc").where("date(convert_tz(posted_when,'UTC',?)) = ? ", ::Rails.application.config.time_zone || "UTC", @day)
    @total=@sales_for_day.inject(Money.new(0)) {|sum,s| sum+s.total}
    
  end


end
