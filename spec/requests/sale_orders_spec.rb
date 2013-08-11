require 'spec_helper'

describe "SaleOrders" do
  describe "GET /sale_orders" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get sale_orders_path
      response.status.should be(200)
    end
  end
end
