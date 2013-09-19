module EditionsHelper
  
  def status_and_price(edition)
    content_tag(:table,
                content_tag(:tr,
                            content_tag(:th,edition.my_stock_status) +
                            content_tag(:td,edition.my_online_price)
                            ),
                :class=>"table status_and_price"
                )
  end
  
  def buy_or_order(edition)
    if edition.has_copies_in_stock?
      content_tag(:div,
                  link_to("Add to cart",
                          edition_path(edition),
                          :class=>"btn btn-large btn-primary block"),
                  :class=>"control-group")
    else
      content_tag(:div,
                  link_to("Sorry, not available",
                          "#maybedoapopupwiththeemail",
                          :class=>"btn btn-large btn-primary block"),
                  :class=>"control-group")
      
    end 
    
  end

end
