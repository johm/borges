class Owner < ActiveRecord::Base

  attr_accessible :name, :notes
  has_many :copies
  has_many :editions, :through => :copies
  has_many :titles, :through => :editions
  has_many :purchase_orders
  has_many :invoices


  def name_and_id
    "#{name} (#{id})"
  end

  def self.default_owner
    Owner.find_or_create_by_name(ENV["DEFAULT_OWNER"] || "default_owner")
  end

  def to_s
    name_and_id
  end

  def merge_stuff_from_owner(unneeded_owner_id)
    raise "PARADOX! BAD!" if id==unneeded_owner_id
    unneeded_owner=Owner.find(unneeded_owner_id)
    raise "NO OWNER BY THAT ID FOUND!" if unneeded_owner.nil?

    unneeded_owner.copies.each do |c|
      c.owner = self
      c.save!
    end

    unneeded_owner.purchase_orders.each do |p|
      p.owner = self
      p.save!
    end

    unneeded_owner.invoices.each do |i|
      i.owner = self
      i.save!
    end

    unneeded_owner.destroy
    
  end

end
