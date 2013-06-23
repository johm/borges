class TitleList < ActiveRecord::Base
  attr_accessible :description, :name, :public, :title_list_memberships_attributes
  has_many :title_list_memberships
  has_many :titles, :through => :title_list_memberships
  accepts_nested_attributes_for :title_list_memberships, :allow_destroy => true  

  def to_s
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end

end
