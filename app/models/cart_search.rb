class CartSearch
  attr_accessor :show_completed, :only_preorders, :no_preorders,:just_pickup,:just_mediamail,:just_prioritymail,:pulled,:unpulled,:email


  def initialize(h)
    @show_completed=false
    h.each { |k,v| send("#{k}=",(v=="1" ? true : (v=="0" ? false : v) )) } unless  h.nil?
  end


  def self.model_name
    ActiveModel::Name.new(self)
  end


  def to_key
    [1]
  end

end  
