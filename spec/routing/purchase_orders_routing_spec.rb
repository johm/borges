require "spec_helper"

describe PurchaseOrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/purchase_orders").should route_to("purchase_orders#index")
    end

    it "routes to #new" do
      get("/purchase_orders/new").should route_to("purchase_orders#new")
    end

    it "routes to #show" do
      get("/purchase_orders/1").should route_to("purchase_orders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/purchase_orders/1/edit").should route_to("purchase_orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/purchase_orders").should route_to("purchase_orders#create")
    end

    it "routes to #update" do
      put("/purchase_orders/1").should route_to("purchase_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/purchase_orders/1").should route_to("purchase_orders#destroy", :id => "1")
    end

  end
end
