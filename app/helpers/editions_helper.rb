module EditionsHelper
  
  def status_and_price(edition)
    content_tag(:table,
                content_tag(:tr,
                            content_tag(:th,"In stock") +
                            content_tag(:td,"$19.95")
                            ),
                :class=>"table status_and_price"
                )
      end

  def buy_or_order(edition)
    content_tag(:div,
                link_to("Add to cart",
                        edition_path(edition),
                        :class=>"btn btn-large btn-primary block"),
                :class=>"control-group")
  end 

end
