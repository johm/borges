module ApplicationHelper
  
  def mytextfield(f,l,m)
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m),
                            :class=>"controls"),
                :class=>"field control-group")
  end

  def mytextarea(f,l,m)
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m),
                            :class=>"controls"),
                :class=>"field control-group")
  end


  def mysubmit(f,l)
    content_tag(:div,
                content_tag(:div,
                            f.submit(:value=>l,:class=>"btn btn-large btn-primary"),
                            :class=>"controls"
                            ),
                :class=>"actions control-group")
  end

end
