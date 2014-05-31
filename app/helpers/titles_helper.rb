module TitlesHelper

  def contributors_list(title)
    title.contributions.collect {|x| link_to(x,x.author)}.to_sentence
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
      raw "<span class='label label-important'>No</span>"
    else
      title.categories.collect {|c| link_to(c.name,c).html_safe}.join("<br />").html_safe
    end
  end

  def ordering_from_info(title)
    begin
      edition=title.latest_published_edition
      copy=edition.copies.last
      content_tag(:div,
                  "Pub: " +
                  link_to(edition.publisher.name, edition.publisher) + 
                  "Dist: " +
                  link_to(copy.distributor,copy.distributor.name),
                  :class=>"small ordering_from_info"
                  )
      rescue
      ""
    end
  end
end
