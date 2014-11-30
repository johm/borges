module EditionsHelper
  
  def status_and_price(edition)
    content_tag(:table,
                content_tag(:tr,
                            content_tag(:th,edition.my_stock_status) +
                            content_tag(:td,edition.has_copies_in_stock? ? ("$"+edition.my_online_price.to_s) : "" )
                            ),
                :class=>"table status_and_price"
                )
  end
  
  def buy_mini(edition) 
    if edition.has_copies_in_stock?
      content_tag(:div,
                  button_to("Add to cart",
                            shopping_cart_line_items_path(:edition=>edition),
                            :class=>"btn btn-mini btn-success block"),
                  :class=>"control-group",:style=>"float:right")
    end
  end
  
  def buy_or_order(edition)
    if edition.has_copies_in_stock?
      content_tag(:div,
                  button_to("Add to cart",
                            shopping_cart_line_items_path(:edition=>edition),
                            :class=>"btn btn-large btn-success block"),
                  :class=>"control-group") +
        content_tag(:small,ENV["ADDTOCARTMESSAGE"].html_safe || "")
    else
      content_tag(:div,
                  "Sorry, not available",
                  :class=>"not-available") +
       content_tag(:small,link_to("Email us about ordering this title","mailto:books@redemmas.org"))
    end 
  end
  
end
