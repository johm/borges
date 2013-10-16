class Owner < ActiveRecord::Base

  attr_accessible :name, :notes
  has_many :copies

  def name_and_id
    "#{name} (#{id})"
  end

  def self.default_owner
    Owner.find_or_create_by_name(ENV["DEFAULT_OWNER"] || "default_owner")
  end

  def to_s
    name_and_id
  end

end
