class ShoppingCart < ActiveRecord::Base
  attr_accessible :session_id, :shipping_address_1, :shipping_address_2, :shipping_city, :shipping_name, :shipping_state, :shipping_zip,:shipping_method,:shipping_email,:shipping_subscribe,:notes,:state_to_toggle, :weight
  has_many :shopping_cart_line_items
  
#  SHIPPING_OPTIONS=[["Pick up at the store<div><small>We'll confirm over email that your book is being held, and you can pick it up any time we are open.</small></div>","Pickup"],["Have it delivered by bike!<div><small>Same day delivery for orders placed before noon. <a href='/pages/bike-delivery' target='_blank'>Click here for restrictions and delivery area map</a></small></div>","Bike"],["Ship it via USPS Priority mail <div><small>US orders only.</small></div>","USPS"]]
  SHIPPING_OPTIONS=[["Pick up at the store<div><small>We'll confirm over email that your book is being held, and you can pick it up any time we are open.</small></div>","Pickup"],["Ship it via USPS Media mail <div><small>US orders only. Shipment can only contain books!</small></div>","USPS Media Mail"],["Ship it via USPS Priority mail <div><small>US orders only.</small></div>","USPS Priority"]]
  validates_inclusion_of :shipping_method, :in => SHIPPING_OPTIONS.collect {|x| x[1]}

  
  def active?
    shopping_cart_line_items != []
  end

  def empty? 
    number_of_items==0
  end
  
  def number_of_items
    shopping_cart_line_items.inject(0) {|sum,li| sum+ li.quantity}
  end

  def number_of_items_with_shippingcosts
    shopping_cart_line_items.find_all {|x| !x.edition.shipsfree? rescue false }.inject(0) {|sum,li| sum+ li.quantity}
  end
    

  def subtotal
    shopping_cart_line_items.inject(Money.new(0)) { |sum,i| sum + (i.cost * i.quantity)}
  end

  def taxable_subtotal
    shopping_cart_line_items.find_all {|x| !x.edition.untaxed? rescue false}.inject(Money.new(0)) { |sum,i| sum + (i.cost * i.quantity)}
  end

  
  def tax
    if (shipping_method=="Pickup" || shipping_method=="Bike" || shipping_state=="MD")
        taxable_subtotal * 0.06
    else #no tax due, we need a report to pull these out!
      Money.new(0)
    end
  end

  def total
    subtotal+shipping_cost+tax
  end

  def shipping_cost
    case shipping_method
    when "Pickup"
      Money.new(0)
    when "Bike"
      Money.new(1000)
    when "USPS Priority"
      if number_of_items_with_shippingcosts > 1 
        Money.new(800) +  Money.new(400)*(number_of_items_with_shippingcosts-1)
      else
        Money.new(800)*number_of_items_with_shippingcosts
      end
    when "USPS Media Mail"
      if number_of_items_with_shippingcosts == 0
        Money.new(0)
      else
        if number_of_items_with_shippingcosts > 1 
          Money.new(350) +  Money.new(50)*(number_of_items_with_shippingcosts-1)
        else
          Money.new(350)*number_of_items_with_shippingcosts
        end
      end
    else
      warn "WTF"
      Money.new(0)
    end
  end

  def ordered?
    submitted?
  end

  def complete
    self.completed=true
    self.completed_when=DateTime.now
    self.save
  end
  
  def submit_order
    self.submitted=true
    self.submitted_when=DateTime.now
    self.deferred=false
    self.completed=false

    #send an email
    OrderMailer.confirmation_email(self).deliver

    self.save!
  end

end
