class OrderMailer < ActionMailer::Base
  default from: "Red Emma's Online Store <bookorders@redemmas.org>"

  def confirmation_email(shopping_cart)
    @shopping_cart = shopping_cart
    mail(to: @shopping_cart.shipping_email, subject: 'Confirmation: Red Emma\'s has received your order!')
  end
  

end
