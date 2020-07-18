class CartSearch
  attr_accessor :show_completed, :only_preorders, :just_pickup,:pulled,:unpulled


  def initialize(h)
    @show_completed=false
    h.each { |k,v| send("#{k}=",v=="1" ? true : false) } unless  h.nil?
  end


  def self.model_name
    ActiveModel::Name.new(self)
  end


  def to_key
    [1]
  end

end  
