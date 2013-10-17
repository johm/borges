module ApplicationHelper

  
  def mytextfield(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m,options),
                            :class=>"controls"),
                :class=>"field control-group")
  end

  def mymoneyfield(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            content_tag(:span,"$",:class=>"add-on")+f.text_field(m,options),
                            :class=>"controls  input-prepend",:style=>"margin-left:20px"),
                :class=>"field control-group")
  end

  def mypercentfield(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m,options)+content_tag(:span,"%",:class=>"add-on"),
                            :class=>"controls  input-append",:style=>"margin-left:20px"),
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


  def mysubmit(f,l,options={},size="btn-large")
    content_tag(:div,
                content_tag(:div,
                            f.submit(options.merge({:value=>l,:class=>"btn btn-primary #{size}"})),
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
    my_unique_id=SecureRandom.uuid
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.autocomplete_field(m,p,:id_element=>"##{m}-#{my_unique_id}",:class=>"theautocomplete")+ 
                            f.hidden_field("#{m}_id",:id=>"#{m}-#{my_unique_id}",:class=>"theid") + 
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


  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def theme
    ENV["THEME"] || "default"
  end
    

  def sitename
      ENV["SITENAME"] || "Borges"
  end

  def layouts
      YAML.load(ENV["LAYOUTS"]) || ["application"]
  end

  
end
