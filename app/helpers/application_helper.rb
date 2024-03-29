module ApplicationHelper
  def current_cart
    begin
      ShoppingCart.find(session[:shopping_cart_id])
    rescue ActiveRecord::RecordNotFound
      warn "Making a new cart!"
      shopping_cart = ShoppingCart.new(:shipping_method=>"Pickup",:shipping_subscribe=>true)
      shopping_cart.save!
      session[:shopping_cart_id] = shopping_cart.id
      shopping_cart
    end
  end
  



  def theme_partial(partial_name,options={})
    render options.merge(:partial => "themes/#{theme}/#{partial_name}")
  end

  def mytextfield(f,l,m,options={},help=nil)
    content_tag(:div,
      f.label(l,:class=>"control-label") +
      content_tag(:div,
        f.text_field(m,options) + (help.nil? ? "" : content_tag(:p,help,:class=>"help-block")) ,
        :class=>"controls"),
      :class=>"field control-group")
  end


  def mydatetimefield(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m,
                                         options.merge({:value => (f.object.send(m).strftime('%Y/%m/%d %H:%M') if f.object.send(m)),:class => "datetimepicker",:autocomplete => "off"})), 
                            :class => "controls ",
                            :style => "margin-left:20px"),
                :class=>"field control-group")
  end

  def mydatefield(f,l,m,options={})
    content_tag(:div,
                f.label(l,:class=>"control-label") +
                content_tag(:div,
                            f.text_field(m,
                                         options.merge({:value => (f.object.send(m).strftime('%Y-%m-%d') if f.object.send(m)),:class => "datepicker",:autocomplete => "off"}))+ 
                            content_tag(:span,
                                        content_tag(:i," ",{"data-date-icon"=>"fa-calendar"}),
                                        :class=>"add-on fa"),
                            :class=>"controls "),
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
          options.merge({:class=>"switch switch-large switch-jumbo"})),
        :class=>"controls"),
      :class=>"field control-group")
  end

  def mytextarea(f,l,m,options={})
    content_tag(:div,
      f.label(l,:class=>"control-label") +
      content_tag(:div,
        f.text_area(m,options.merge({:class=>"input-xxlarge whizzy"})),
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



  def myselectfield (f,m,l,p,a=false,id=nil)
    my_unique_id=SecureRandom.uuid
    (id=f.object.send(m).id unless f.object.send(m).nil?)  if id.nil?
    content_tag(:div,
      f.label(l,:class=>"control-label") +
      content_tag(:div,
        f.autocomplete_field(m,p,:id_element=>"##{m}-#{my_unique_id}",:class=>"theautocomplete")+
        f.hidden_field("#{m}_id",:id=>"#{m}-#{my_unique_id}",:class=>"theid",:value=>id) +
        " " +
        (a ? content_tag(:a,
            "+",
            {:href=>a,:class=>"btn",:target=>"_blank"}
          ) : ""),
        :class=>"controls"),
      :class=>"field control-group")
  end

  def my_autocomplete_field_tag (f,m,l,p,extra="",size="",default_value="")
    content_tag(:div,
      f.label(l,:class=>"control-label") +
      content_tag(:div,
                  autocomplete_field_tag(m,"",p,:min_length => 5,:class=>size,:value=>default_value) + " " + extra,
        :class=>"controls"),
      :class=>"field control-group")
  end







  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def menubar(choices) 
    choices.collect {|key,value| menubarlink(key,value[0],value[1])}.join(" ")
  end

  def mobilemenubar(choices) 
    choices.collect {|key,value| mobilemenubarlink(key,value[0],value[1])}.join(" ")
  end


  def menubarlink(text,path,sublist)
    content_tag("div",link_to(image_tag("#{theme}/#{text}.png")+text,path)+content_tag("div",content_tag("div",theme_partial("menu_#{text}")+submenubar(sublist).html_safe,{:class=>'menusubinner'}),{:id=>"menubar_sub_#{text}",:class=>'menusub'}),{:class=>'menuwrapper'})
  end

  def mobilemenubarlink(text,path,sublist)
    content_tag("div",link_to(text,path)+content_tag("div",content_tag("div",theme_partial("menu_#{text}")+submenubar(sublist).html_safe,{:class=>'bottommenusubinner'}),{:id=>"bottommenubar_sub_#{text}",:class=>'bottommenusub'}),{:class=>'bottommenuwrapper'})
  end



  def submenubar(choices)
    choices.collect {|key,value| submenubarlink(key,value)}.join(" ")
  end

  def submenubarlink(text,path)
    link_to text,path
  end

  def theme
    ENV["THEME"] || "default"
  end

  def fullwidth? 
    return controller.controller_name.in? ["dashboard","invoices","purchase_orders","sales_orders","titles"] 
  end

  def sitename
    ENV["SITENAME"] || "Borges"
  end

  def layouts
    YAML.load(ENV["LAYOUTS"] || "") || ["application"]
  end

  def user_is_admin?
    current_user && current_user.roles.include?(Role.find_by_name('admin'))
  end

  def user_is_scheduler?
    current_user && current_user.roles.include?(Role.find_by_name('scheduler'))
  end

  def user_views_calendar?
    current_user && current_user.roles.include?(Role.find_by_name('checkcalendar'))
  end
  

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def us_states
    [
     ['',''],
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
end



end
