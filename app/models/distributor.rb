class Distributor < ActiveRecord::Base
  attr_accessible :name, :notes, :our_account_number

#  has_many :copies
#  has_many :editions, :through => :copies
  has_many :invoice_line_items, :through => :invoices
  has_many :copies, :through => :invoice_line_items
  has_many :editions, :through => :copies, :uniq=>true
  has_many :titles, :through => :editions, :uniq=>true
  has_many :purchase_orders
  has_many :invoices
  has_many :return_orders

  def to_s 
    name_and_id
  end

  def name_and_id
    "#{name} (#{id})"
  end



  def merge_stuff_from_distributor(unneeded_distributor_id)
    
    begin
      unneeded_distributor=Distributor.find(unneeded_distributor_id)
    rescue
      unneeded_distributor=nil
    end

    if self.id==unneeded_distributor_id.to_i || unneeded_distributor.nil?
      return false
    end
    
    [:return_orders,:purchase_orders,:invoices].each do |m|
      unneeded_distributor.send(m).each do |e|
        e.distributor = self
        e.save!
      end
    end
    
    if self.our_account_number.blank? && ! unneeded_distributor.our_account_number.blank?
      self.our_account_number=unneeded_distributor.our_account_number
    end

    if self.notes.blank? && ! unneeded_distributor.notes.blank?
      self.notes=unneeded_distributor.notes
    end
    self.save!
    unneeded_distributor.destroy
  end



end
