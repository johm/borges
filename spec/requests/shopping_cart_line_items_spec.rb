require 'spec_helper'

describe "ShoppingCartLineItems" do
  describe "GET /shopping_cart_line_items" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get shopping_cart_line_items_path
      response.status.should be(200)
    end
  end
end
