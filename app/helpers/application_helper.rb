module ApplicationHelper
  def vendor_template(name)
    render file: File.join("vendor/templates", name)
  end

  def mytextfield(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m,options),
                            :class=>"controls"),
                :class=>"field control-group")
  end

  def myselector(f,l,m,ofs,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.select(m,ofs,options),
                            :class=>"controls"),
                :class=>"field control-group")
  end



  def mycheckbox(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            content_tag(:div,
                                        f.check_box(m),
                                        options.merge({:class=>"switch switch-large"})),
                            :class=>"controls"),
                :class=>"field control-group")
  end

  def mytextarea(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.cktext_area(m,options.merge({:class=>"input-xxlarge"})),
                            :class=>"controls"),
                :class=>"field control-group")
  end


  def myplaintextarea(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_area(m,options.merge({:class=>"input-xxlarge"})),
                            :class=>"controls"),
                :class=>"field control-group")
  end


  def mysubmit(f,l,options={})
    content_tag(:div,
                content_tag(:div,
                            f.submit(options.merge({:value=>l,:class=>"btn btn-large btn-primary"})),
                            :class=>"controls"
                            ),
                :class=>"actions control-group")
  end


  def mylinkbutton(text,path,options={},size="btn-large")
    content_tag(:div,
                content_tag(:a,
                            raw(text),
                            options.merge({:href=>path,:class=>"btn #{size} btn-primary controls"})
                            ),
                :class=>"actions control-group")
  end


  def mypostlinkbutton(text,path,url_options={},html_options={},size="btn-large")
    content_tag(:div,
                link_to(raw(text),
                        path,
                        url_options.merge({:method=>:post,:class=>"btn #{size} btn-primary controls"})
                        ),
                :class=>"actions control-group")
  end



  def myselectfield (f,m,l,p,a=false)
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.autocomplete_field(m,p,:id_element=>"##{m}-#{f.my_unique_id}")+
                            f.hidden_field("#{m}_id",:id=>"#{m}-#{f.my_unique_id}") +
                            " " +
                            (a ? content_tag(:a,
                                             "+",
                                             {:href=>a,:class=>"btn",:target=>"_blank"}
                                             ) : ""),
                            :class=>"controls"),
                :class=>"field control-group")
  end

  def my_autocomplete_field_tag (f,m,l,p,extra="")
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            autocomplete_field_tag(m,"",p) + " " + extra,
                            :class=>"controls"),
                :class=>"field control-group")
  end




end
