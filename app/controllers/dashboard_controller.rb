class DashboardController < ApplicationController

  before_filter :authenticate_user! 
  authorize_resource :class => false

  autocomplete :publisher,:name,:full=>true,:display_value=>:name_and_id,:limit => 20
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


  def snipcart
    begin
      @response=JSON.parse((RestClient.get "https://#{ENV['SNIPCART_KEY']}:@app.snipcart.com/api/orders", {params: {limit: 1000},:accept => :json}))
      @order_to_notifications={}
      @response['items'].each do |order|
        @order_to_notifications[order['token']]=JSON.parse((RestClient.get "https://#{ENV['SNIPCART_KEY']}:@app.snipcart.com/api/orders/#{order['token']}/notifications", {params: {limit: 1000},:accept => :json}))
      end 

    rescue RestClient::ExceptionWithResponse => e
      @error = e.response
    end
  end


  def sales
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date

    timezone=::Rails.application.config.time_zone || "UTC"
    

    @sales_by_date=SaleOrder.includes(:sale_order_line_items => [:copy => [:edition => [:title]]]).where(:posted => true).order("created_at asc").where("convert_tz(posted_when,'UTC','#{timezone}') > ? && convert_tz(posted_when,'UTC','#{timezone}') < ?",@date_range_object.range_start,@date_range_object.range_end+1.days).group_by{ |so| so.posted_when.to_date }
    
    @invoices=Invoice.where(:received => true).where(:received_when => @date_range_object.range_start..@date_range_object.range_end)  
    @shipping_costs=@invoices.inject(Money.new(0)) {|sum,i| sum + i.shipping_cost }

    @shopping_carts=ShoppingCart.where(:submitted => true).where(:submitted_when => @date_range_object.range_start..@date_range_object.range_end)  
    @shipping_income=@shopping_carts.inject(Money.new(0)) {|sum,i| sum + i.shipping_cost }
    @tax_exempt_sales=@shopping_carts.find_all {|x| not x.is_taxable?}.inject(Money.new(0)) {|sum,i| sum + i.taxable_subtotal }



    @days=@sales_by_date.keys.sort
    
#    @saleschart = LazyHighCharts::HighChart.new('column') do |f|
#      f.series(:name=>'Books & Merch',:data=> @days.collect {|d| @sales_by_date[d].inject(0) {|sum,s| sum+(s.subtotal_after_discount).to_f} } )
#      f.title({ :text=>"Sales"})
#      f.xAxis(:categories => @days)
#    end    

    @revenue=@days.inject(Money.new(0)) {|sum,d| sum + @sales_by_date[d].inject(Money.new(0)) {|sum2,s| sum2 + s.subtotal_after_discount} }
    @cost=@days.inject(Money.new(0)) {|sum,d| sum + @sales_by_date[d].inject(Money.new(0)) {|sum2,s| sum2 + s.cost} }
    
    @titles_sold_with_count=@days.collect {|d| @sales_by_date[d].collect {|s| s.sale_order_line_items.collect {|li| li.copy.edition.title}}}.flatten.flatten.flatten.inject(Hash.new(0)) {|h,i| h[i] += 1; h}.sort_by{|k,v| v}.reverse      
  
    @format_to_total={}
    @section_to_total={}
    @distributor_to_total={}

    all_line_items=@sales_by_date.collect_concat {|d,sales| sales.collect_concat {|sales| sales.sale_order_line_items}}

    all_line_items.group_by {|l| l.copy.edition.format}.each do |f,items_sold|
      @format_to_total[f] = items_sold.inject(Money.new(0)) {|formatsum,item| formatsum+item.sale_price}
    end

    all_line_items.group_by {|l| l.copy.edition.title.last_distributor.name rescue "unknown"}.each do |f,items_sold|
      @distributor_to_total[f] = items_sold.inject(Money.new(0)) {|formatsum,item| formatsum+item.sale_price}
    end


    all_line_items.each do |l|
      my_cats=l.copy.title.categories
      if my_cats.length > 0 
        cat_weight=1.0/my_cats.length
        my_cats.each do |c|
          @section_to_total[c.name] = Money.new(0) if @section_to_total[c.name].nil?
          @section_to_total[c.name] += (l.sale_price * cat_weight)
        end
      else
        @section_to_total["uncategorized"] = Money.new(0) if @section_to_total["uncategorized"].nil?
        @section_to_total["uncategorized"] += l.sale_price
      end
      
    end

    
    @prediscount_total=@format_to_total.values.inject(Money.new(0)) {|s,v| s+v}

    

#    @formatchart = LazyHighCharts::HighChart.new('pie') do |f|
#      f.chart({:defaultSeriesType=>"pie" } )
#      f.series(:type=>'pie',:name=>'Merchandise',:data=> @format_to_total.collect {|k,v| [k,((v/@prediscount_total) *100)  ]})
#      f.title({ :text=>"Sales by format"})
      
#    end    

#    @sectionchart = LazyHighCharts::HighChart.new('pie') do |f|
#      f.chart({:defaultSeriesType=>"pie" } )
#      f.series(:type=>'pie',:name=>'Merchandise',:data=> @section_to_total.collect {|k,v| [k,((v/@prediscount_total) *100)  ]})
#      f.title({ :text=>"Sales by section"})
      
#    end    
    
 
  end


  def simplesales
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date

    timezone=::Rails.application.config.time_zone || "UTC"
    

    @sales_by_date=SaleOrder.includes(:sale_order_line_items => [:copy => [:edition => [:title]]]).where(:posted => true).order("created_at asc").where("convert_tz(posted_when,'UTC','#{timezone}') > ? && convert_tz(posted_when,'UTC','#{timezone}') < ?",@date_range_object.range_start,@date_range_object.range_end+1.days).group_by{ |so| so.posted_when.to_date }
    
    @days=@sales_by_date.keys.sort
    
    @revenue=@days.inject(Money.new(0)) {|sum,d| sum + @sales_by_date[d].inject(Money.new(0)) {|sum2,s| sum2 + s.subtotal_after_discount} }
    @cost=@days.inject(Money.new(0)) {|sum,d| sum + @sales_by_date[d].inject(Money.new(0)) {|sum2,s| sum2 + s.cost} }
    
    @titles_sold_with_count=@days.collect {|d| @sales_by_date[d].collect {|s| s.sale_order_line_items.collect {|li| li.copy.edition.title rescue Title.find(41594)}}}.flatten.flatten.flatten.inject(Hash.new(0)) {|h,i| h[i] += 1; h}.sort_by{|k,v| v}.reverse      
   
  end


  def report_aba
    # sunday to saturday
    @date_range_object=DateRangeObject.new
    
    if Date.today.wday==0 # we are reporting on sunday
      @date_range_object.range_start = Date.today-1.week #get last sunday
      @date_range_object.range_end = Date.today-1.day # until yesterday
    elsif Date.today.wday==6 # we are reporting at the end of Saturday
      @date_range_object.range_start = Date.today-6.days #get last sunday
      @date_range_object.range_end = Date.today # until today
    else
      @date_range_object.range_start = Date.today.monday-1.day-1.week #get last sunday
      @date_range_object.range_end = Date.today.monday-2.days #until the saturday that just past
    end
        
    timezone=::Rails.application.config.time_zone || "UTC"

    @sales_by_date=SaleOrder.includes(:sale_order_line_items => [:copy => [:edition => [:title]]]).where(:posted => true).order("created_at asc").where("convert_tz(posted_when,'UTC','#{timezone}') > ? && convert_tz(posted_when,'UTC','#{timezone}') < ?",@date_range_object.range_start,@date_range_object.range_end+1.days)
    @isbns_sold=@sales_by_date.collect {|s| s.sale_order_line_items.find_all {|soli| soli.copy.edition && !soli.copy.edition.isbn13.blank?}}.flatten.collect{|soli| soli.copy.edition.isbn13} 
    @isbns_sold_with_count=@isbns_sold.inject(Hash.new(0)){|h,i| h[i] += 1;h}.sort_by{|k,v| v}.reverse
    
    @csv=CSV.generate do |csv|
      csv << ["Quantity","ISBN13"]
      @isbns_sold_with_count.each do |k,v|
        csv << [v,k]
      end    
    end 
    


    respond_to do |format|
      format.csv { 
        response.headers['Content-Disposition'] = "attachment; filename=\"redemmas-aba-#{@date_range_object.range_start.strftime('%a-%b-%e')}-to-#{@date_range_object.range_end.strftime('%a-%b-%e-%Y')}.csv\""  
        render text: @csv 
      }
    end

    
    
  end





  def losses
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date
    
    timezone=::Rails.application.config.time_zone || "UTC"
    @losses=Copy.where(:status => ["RETURNED","PROBABLYRETURNED","LOST"]).where(:deinventoried_when => @date_range_object.range_start..@date_range_object.range_end)
    @total_cost_lost=@losses.find_all {|c| c.status=="LOST"}.inject(Money.new(0)) {|sum,c| sum+c.cost}
    @total_cost_returned=@losses.find_all {|c| c.status=="RETURNED"}.inject(Money.new(0)) {|sum,c| sum+c.cost}
    @total_cost_probablyreturned=@losses.find_all {|c| c.status=="PROBABLYRETURNED"}.inject(Money.new(0)) {|sum,c| sum+c.cost}
    
    end


  def content 
    @top_level_pages=Page.where("parent_id is ?",nil)
    @posts=Post.order("created_at desc")  #TODO pagination
    @post_categories=PostCategory.order("name asc")  #TODO pagination
  end

  def manage_calendar
    @events=Event.where("event_start > ?",Time.now)
    @event_locations=EventLocation.all


    @year = (params[:year] || DateTime.now.year).to_i
    @month = (params[:month] || DateTime.now.month).to_i


    @calendar_events = Event.by_year(@year).by_month(@month)    
    @calendar_event_shifts=@calendar_events.collect {|x| x.event_shifts}.flatten.sort {|x,y| x.event_staffer.name <=> y.event_staffer.name rescue ""}
    
    # do the awesome for scheduling
    @ical=nil
    begin
      open(ENV["DATEHOLDS"])do |cal|
        @ical = RiCal.parse(cal)
      end
    rescue
      @ical=[]
    end

    if @import_to_location=EventLocation.find_by_title("Date Holds") #because otherwise you don't care!
      @ical.each do |calendar|
        calendar.events.each do |event|
        fake_event = Event.new
          fake_event.event_location = @import_to_location
          
          add_this_to_time=0
          if ! Time.zone.parse("#{event.dtstart.to_s}").dst?
#              add_this_to_time=1
          end
 
          fake_event.event_start=event.dtstart+add_this_to_time.hour
          fake_event.event_end=event.dtend+add_this_to_time.hour
          
          fake_event.title=event.summary
          @previous=@calendar_events.find_all {|c| c.title==fake_event.title && c.event_start==fake_event.event_start}# weird duplication in the feed 
          if  @previous.length==0 && fake_event.event_start.year == @year && fake_event.event_start.month == @month
            @calendar_events << fake_event
          end
        end
      end    
    end


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
    
    respond_to do |format|
      format.html {}
      format.csv {
        @csv=CSV.generate do |csv|
          csv << ["Title","ISBN13","Copies in Stock"]
          @copies_sold=@sales.collect do |s|
            s.sale_order_line_items.select {|l| l.copy.owner==@date_range_object.owner}
          end.flatten

          @copies_sold.inject(Hash.new(0)) { |h, lineitem| h[lineitem.copy.edition] += 1 ; h }.each do |edition,count| 
            csv << [edition.title,edition.isbn13,count]
          end 
        end
        response.headers['Content-Disposition'] = "attachment; filename=\"redemmas-consignment-#{@date_range_object.owner.name}.csv\""  
        render text: @csv 
      }   
    end
  end

  def daily 
    @day=params[:day] ? Date.parse(params[:day]) : DateTime.now.in_time_zone(::Rails.application.config.time_zone || "UTC").to_date
    @sales_for_day=SaleOrder.where(:posted => true).order("created_at asc").where("date(convert_tz(posted_when,'UTC',?)) = ? ", ::Rails.application.config.time_zone || "UTC", @day)
    @total=@sales_for_day.inject(Money.new(0)) {|sum,s| sum+s.subtotal_after_discount}
  end

  def purchases_by_date_and_owner
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date
    @owner=Owner.find(params[:date_range_object][:owner_id]) rescue nil
    
    @invoices=[]
    
    if !@owner.nil?
      @invoices=Invoice.where(:received => true,:owner_id=> @owner).where(:received_when => @date_range_object.range_start..@date_range_object.range_end) 
      @cost=@invoices.inject(Money.new(0)) {|sum,i| sum+i.total_cost}
      @shipping=@invoices.inject(Money.new(0)) {|sum,i| sum+i.shipping_cost}
    end
  end

  def ownerflow
    @date_range_object=DateRangeObject.new
    @date_range_object.range_start = Date.parse(params[:date_range_object][:range_start]) rescue 6.days.ago.to_date
    @date_range_object.range_end = Date.parse(params[:date_range_object][:range_end]) rescue 0.days.ago.to_date
    @date_range_object.owner=Owner.find(params[:date_range_object][:owner_id]) rescue nil
    @owner = @date_range_object.owner
    if ! @date_range_object.owner.nil?
      @copies_inventoried_for_period=Copy.includes(invoice_line_item: [purchase_order_line_item: [:purchase_order]]).where(:owner_id=> @owner).where(:inventoried_when => @date_range_object.range_start..@date_range_object.range_end)
      @invoices_for_period=Invoice.where(:received => true,:owner_id=> @owner).where(:received_when => @date_range_object.range_start..@date_range_object.range_end)
      @purchases=@invoices_for_period.inject(Money.new(0)) {|sum,i| sum+i.total_cost}

      @returns_for_period=Copy.includes(invoice_line_item: [purchase_order_line_item: [:purchase_order]]).where(:status => "RETURNED",:owner_id=> @owner).where(:deinventoried_when => @date_range_object.range_start..@date_range_object.range_end)
      @returns=@returns_for_period.inject(Money.new(0)) {|sum,c| sum+c.cost}

      @copies_sold_for_period=Copy.includes(invoice_line_item: [purchase_order_line_item: [:purchase_order]]).where(:status => "SOLD",:owner_id=> @owner).where(:deinventoried_when => @date_range_object.range_start..@date_range_object.range_end)
      @sales_cost=@copies_sold_for_period.inject(Money.new(0)) {|sum,c| sum+c.cost}
      @sales_price=@copies_sold_for_period.inject(Money.new(0)) {|sum,c| sum+c.price}
      
      @copies_lost_for_period=Copy.includes(invoice_line_item: [purchase_order_line_item: [:purchase_order]]).where(:status => "LOST",:owner_id=> @owner).where(:deinventoried_when => @date_range_object.range_start..@date_range_object.range_end)
      @lost=@copies_lost_for_period.inject(Money.new(0)) {|sum,c| sum+c.cost}
      
      @copies_probablyreturned_for_period=Copy.includes(invoice_line_item: [purchase_order_line_item: [:purchase_order]]).where(:status => "PROBABLYRETURNED",:owner_id=> @owner).where(:deinventoried_when => @date_range_object.range_start..@date_range_object.range_end)
      @probablyreturned=@copies_probablyreturned_for_period.inject(Money.new(0)) {|sum,c| sum+c.cost}


    end
  end

  def inventory_report_by_owner
# might be broken
    @date_range_object=DateRangeObject.new
    @date_range_object.date=Date.parse(params[:date_range_object][:date]) rescue 0.days.ago.to_date
    @date_range_object.owner=Owner.find(params[:date_range_object][:owner_id]) rescue nil
    @owner=@date_range_object.owner
    
    unless @owner.nil?
      @copies_in_stock=Copy.instock.where(:owner_id=> @owner).order("edition_id ASC,inventoried_when ASC") +  Copy.where(:deinventoried_when => @date_range_object.date..(DateTime.now+100.years)).order("edition_id ASC,inventoried_when ASC")
      @copies_lost=Copy.where(:deinventoried_when => (DateTime.now-100.years)..@date_range_object.date).lost.where(:owner_id=> @owner).order("edition_id ASC, deinventoried_when ASC")
      @copies_returned=Copy.where(:deinventoried_when => (DateTime.now-100.years)..@date_range_object.date).returned.where(:owner_id=> @owner).order("edition_id ASC, deinventoried_when ASC")
      @copies_sold=Copy.where(:deinventoried_when => (DateTime.now-100.years)..@date_range_object.date).sold.where(:owner_id=> @owner).order("edition_id ASC, deinventoried_when ASC")
      
  end    
  respond_to do |format|
    format.html {}
      format.csv {
        @csv=CSV.generate do |csv|
          csv << ["Title","ISBN13","Copies in Stock"]
          @copies_in_stock.inject(Hash.new(0)) { |h, copy| h[copy.edition] += 1 ; h }.each do |edition,count| 
            csv << [edition.title,edition.isbn13,count]
          end 
        end
        response.headers['Content-Disposition'] = "attachment; filename=\"redemmas-inventory-#{@owner.name}.csv\""  
        render text: @csv 
      }   
    end
  end

  def inventory_value_by_date_and_owner
    @date_range_object=DateRangeObject.new
    @date_range_object.date=Date.parse(params[:date_range_object][:date]) rescue 0.days.ago.to_date
    @date_range_object.owner=Owner.find(params[:date_range_object][:owner_id]) rescue nil

    if ! @date_range_object.owner.nil?
      inventoried_items_inventoried_before_the_date_which_are_still_in_stock=Copy.instock.where(:owner_id=> @date_range_object.owner).where(:inventoried_when => (DateTime.now-100.years)..@date_range_object.date)

      deinventoried_items_inventoried_before_the_date_which_were_still_in_stock_on_that_date=Copy.where(:owner_id=> @date_range_object.owner).where(:inventoried_when => (DateTime.now-100.years)..@date_range_object.date).where("status ='SOLD' or status='RETURNED' or status='LOST' ").where(:deinventoried_when => @date_range_object.date..(DateTime.now+100.years))


      @number_of_copies = inventoried_items_inventoried_before_the_date_which_are_still_in_stock.size + deinventoried_items_inventoried_before_the_date_which_were_still_in_stock_on_that_date.size
      @cost = 
        [inventoried_items_inventoried_before_the_date_which_are_still_in_stock,
         deinventoried_items_inventoried_before_the_date_which_were_still_in_stock_on_that_date].inject(Money.new(0)) do |sum,c| 
        sum+c.inject(Money.new(0)) {|innersum,innerc| innersum + innerc.cost}
        
        
      end
      
    end
  end



end
