class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :bio, :full_name
  has_many :contributions
  has_many :titles, :through => :contributions

  before_save :set_first_last_and_full_name
  
  searchable do
    text :full_name

    integer :titles do
      titles.length
    end

    text :bio
  end

  def slug
    full_name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/-$/,"")    
  end

  def to_param
    "#{id}-#{slug}"
  end


  def to_s 
    full_name
  end
  
  def set_first_last_and_full_name 
    if (full_name && (first_name.blank?  && last_name.blank?))
        split_name=full_name.rpartition(" ")
        self.first_name=split_name[0]
        self.last_name=split_name[2]
      else
        self.full_name = "#{first_name} #{last_name}"
      end
  end
  
  def set_full_name

  end

  def name_and_id
    "#{full_name} (#{id})"
  end

  def name_and_id_and_titles
    "#{full_name} (#{id}) [#{titles.length} title(s)]"
  end


end
