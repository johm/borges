class Publisher < ActiveRecord::Base
  attr_accessible :description, :name, :notes
  has_many :editions
  has_many :titles, :through => :editions  

  def to_s 
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end

  def name_and_editions
    "#{name} (#{editions.count} editions)"
  end
  

  def merge_stuff_from_publisher(unneeded_publisher_id)
    
    begin
      unneeded_publisher=Publisher.find(unneeded_publisher_id)
    rescue
      unneeded_publisher=nil
    end

    if self.id==unneeded_publisher_id.to_i || unneeded_publisher.nil?
      return false
    end
          
    unneeded_publisher.editions.each do |e|
      e.publisher = self
      e.save!
    end
    unneeded_publisher.destroy

  end

end
