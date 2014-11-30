

module ShoppingCartsHelper

  def endicia_url(shopping_cart)
    require "addressable/uri"
    uri = Addressable::URI.parse("endicia://newShipment2/?ToAddress")
    uri.query_values = {
      'ToAddress'  => "#{shopping_cart.shipping_address_1} #{shopping_cart.shipping_address_2} #{shopping_cart.shipping_state} #{shopping_cart.shipping_zip}",
      'ReferenceID' => shopping_cart.id,
      'ToEmail' => shopping_cart.shipping_email,
      'MailClass' => shopping_cart.shipping_method=="USPS Media Mail" ? "MEDIAMAIL" : "PRIORITY" ,
      'USPSTracking' => 'ON',
      'Value' => shopping_cart.subtotal.to_s
    }

    return uri.to_s
  end


end
