module TitlesHelper

  def contributors_list(title)
    title.contributions.collect {|x| link_to(x,x.author)}.to_sentence
  end

  def usefully_sorted(titles)
    titles.sort_by {|x| [-x.in_stock,-(x.latest_published_edition.nil? || x.latest_published_edition.year_of_publication.nil? ? 0 : x.latest_published_edition.year_of_publication) ]}
  end





  def make_a_grid_from_tlm(title_list_memberships)
    title_list_memberships.each_with_index.collect do |tlm,i|
      capture do 
        concat render :partial=>'titles/gridtitle', :locals=>{:title=>tlm.title,:text=>(tlm.notes || "") } unless tlm.title.nil? 
        if i % 6 == 5 
        concat content_tag(:div,"", :class=>"clearfix visible-md-block visible-lg-block visible-sm-block visible-xs-block")
        elsif i % 3 == 2
          concat content_tag(:div,"", :class=>"clearfix visible-sm-block")
        elsif i % 2 == 1
          concat content_tag(:div,"", :class=>"clearfix visible-xs-block")
        end
      end
    end.join.html_safe
  end

  def make_a_grid_from_titles(titles)
    titles.each_with_index.collect do |t,i|
      capture do 
        concat render :partial=>'titles/gridtitle', :locals=>{:title=>t,:text=>("") } unless t.nil? 
        if i % 6 == 5 
        concat content_tag(:div,"", :class=>"clearfix visible-md-block visible-lg-block visible-sm-block visible-xs-block")
        elsif i % 3 == 2
          concat content_tag(:div,"", :class=>"clearfix visible-sm-block")
        elsif i % 2 == 1
          concat content_tag(:div,"", :class=>"clearfix visible-xs-block")
        end
      end
    end.join.html_safe
  end

  

  def blurb_status(title)
    if title.introduction.blank?
      raw "<span class='label label-important'>No</span>"
    else
      raw "<span class='label label-success'>Yes</span>"
    end
  end
  
  def category_status(title)
    if title.categories.length==0
      raw "<span id='nocategories'><span class='label label-important'>No</span></span>"
    else
      "<span id='somecategories'>" + title.categories.collect {|c| link_to(c.name,c).html_safe}.join("<br />").html_safe + "</span>"
    end
  end

  def ordering_from_info(title)

    edition=title.latest_published_edition
    begin 
      copy=edition.copies.last
      content_tag(:div,
                  content_tag(:small,
                              "Pub: ".html_safe +
                              (edition.publisher.nil? ? "?" : link_to(edition.publisher.name, edition.publisher)).html_safe + 
                              "<br /> Dist: ".html_safe + 
                              (copy.nil? || copy.invoice_line_item.nil? ? "?" : link_to(copy.invoice_line_item.invoice.distributor.try(:name),copy.invoice_line_item.invoice.distributor)).html_safe,
                              :class=>"ordering_from_info muted"
                              ).html_safe
                  ).html_safe
    rescue 
      ""
    end
  end
end
